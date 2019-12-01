//
//  TransactionsViewController.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var transactions = Model.shared.transactions()
    var filteredTransactions = [Transaction]()
    var searchFilter = "" {
        didSet {
            updateSearchResults()
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController?

    private var searchPredicate: NSPredicate = NSPredicate.init(value: true) {
        didSet {
            updateSearchResults()
            self.tableView.reloadData()
        }
    }
    
    /// Pivate boolean flag to prevent uI updates when UI is not ready yet.
    private var resultsAreShown = false
    private func reloadHeader() {
        if searchController?.isActive == true && resultsAreShown == true {
            let header = TransactionSearchResultHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 250))
            let totalIncome = filteredTransactions.reduce(0) { (result, tx) -> Money in
                if let tx = tx as? IncomeTransaction {
                    return result + tx.value
                } else {
                    return result
                }
            }
            let totalExpense = filteredTransactions.reduce(0) { (result, tx) -> Money in
                if let tx = tx as? ExpenseTransaction {
                    return result + tx.value
                } else {
                    return result
                }
            }
            header.addTotalCard(income: totalIncome, expense: totalExpense)
            
            header.addPerMonthSpending(expenses: filteredTransactions.monthlyExpenses())
            header.addPerMonthIncome(incomes: filteredTransactions.monthlyIncomes())
            header.addPerCategorySpending(spendingsPerCategory: filteredTransactions.spendingsPerCategory())
            tableView.tableHeaderView = header
        } else {
            tableView.tableHeaderView = nil
        }
    }
    
    private func updateSearchResults() {
        // In iOS 13 we use nspredicate from TransactionSearchSuggestions
        if #available(iOS 13.0, *) {
            filteredTransactions = transactions.filter { searchPredicate.evaluate(with: $0) }
            
            return
        }
        
        if searchFilter == "" {
            filteredTransactions = transactions
        } else {
            filteredTransactions = transactions.filter({ (tx) -> Bool in
                tx.transactionDescription.lowercased().contains(searchFilter.lowercased())
            })
        }
    }
    
    @objc private func updateModel() {
        transactions = Model.shared.transactions()
        updateSearchResults()
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? CategoryTransacitonCell else {
            return UITableViewCell()
        }
        let tx = filteredTransactions[indexPath.row]
        
        cell.nameLabel.text = tx.transactionDescription
        cell.moneyLabel.text = "\(tx.value)"
        let localizedDateString = DateFormatter.localizedString(from: tx.date, dateStyle: .medium, timeStyle: .none)
        cell.dateLabel.text = localizedDateString

        if let expenseTx = tx as? ExpenseTransaction  {
            cell.accountLabel.text = expenseTx.account
            cell.moneyLabel.textColor = .expenseColor
            cell.colorStyle = .expense
        }

        if let incomeTx = tx as? IncomeTransaction {
            cell.accountLabel.text = incomeTx.account
            cell.moneyLabel.textColor = .incomeColor
            cell.colorStyle = .income
        }
        
        if let transferTx = tx as? TransferTransaction {
            cell.accountLabel.text = "From \(transferTx.fromAccount) to \(transferTx.toAccount)"
            cell.moneyLabel.textColor = .transferColor
            cell.colorStyle = .transfer
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tx = filteredTransactions[indexPath.row]

            // First, animate deletion
            filteredTransactions.remove(at: indexPath.row)
            tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            // Second, delete in model. This will automatically trigger a ModelDidChange notification and thus reload the table view again
            let toberemoved = tx.ledgerTransaction()
            LedgerModel.shared().removeTransaction(tx: toberemoved)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tx = filteredTransactions[indexPath.row]
        if let expenseTx = tx as? ExpenseTransaction  {
            navigationController?.pushViewController(ExpenseDetailTableViewController.init(transaction: expenseTx), animated: true)
        } else if let incomeTx = tx as? IncomeTransaction {
            navigationController?.pushViewController(IncomeDetailTableViewController.init(transaction: incomeTx), animated: true)
        } else if let transferTx = tx as? TransferTransaction {
            navigationController?.pushViewController(TransferDetailTableViewController.init(transaction: transferTx), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFilter = "" // No filter at start
        
        if #available(iOS 13.0, *) {
            // Advanced search functionality for iOS 13 and up
            let resultsVC = TransactionSearchTableViewController.instantiate()
            resultsVC.delegate = self
            searchController = TokenSearchController.init(searchResultsController: resultsVC)
            searchController?.searchResultsUpdater = resultsVC
            searchController?.delegate = self
            searchController?.obscuresBackgroundDuringPresentation = false
            navigationItem.searchController = searchController
        } else {
            // Basic search functionalty for iOS 12 (only filter name)
            searchController = UISearchController.init(searchResultsController: nil)
            searchController?.searchResultsUpdater = self
            searchController?.obscuresBackgroundDuringPresentation = false
            navigationItem.searchController = searchController
        }

        searchController?.searchBar.placeholder = "Search all transactions"

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateModel), name: ModelChangedNotification, object: nil)

        // Update transaction data, when the view is loaded for the first time
        // This is necessary, because in other view controllers, the user might change transaction data at runtime (e.g. add another transaction)
        // And at this point of change, this VC has not been a registered observer of the ModelChangedNotification
        updateModel()
    }
    
    private func animateResultsVC() {
        guard let resultsVC = searchController?.searchResultsController else {
            return
        }
        guard let searchView = searchController?.view else {
            return
        }
        
        let offset: CGFloat = 300
        let topConstr = NSLayoutConstraint.init(item: resultsVC.view!, attribute: .top, relatedBy: .equal, toItem: searchView, attribute: .top, multiplier: 1, constant: offset)

        DispatchQueue.main.async {
            self.navigationController?.navigationBar.sizeToFit()
            resultsVC.view.translatesAutoresizingMaskIntoConstraints = false

            // Move view farther down that the correct position
            NSLayoutConstraint.activate([
                topConstr,
                NSLayoutConstraint.init(item: resultsVC.view!, attribute: .left, relatedBy: .equal, toItem: searchView, attribute: .left, multiplier: 1, constant: 0),
                NSLayoutConstraint.init(item: resultsVC.view!, attribute: .bottom, relatedBy: .equal, toItem: searchView, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint.init(item: resultsVC.view!, attribute: .right, relatedBy: .equal, toItem: searchView, attribute: .right, multiplier: 1, constant: 0),
            ])

            UIView.animate(withDuration: 0.001, animations: {
                // Initially, place the view farther down. Not hidden , but with alpha 0
                resultsVC.view.layoutIfNeeded()
                self.view.layoutIfNeeded()
                resultsVC.view.alpha = 0.0
                resultsVC.view.isHidden = false
            }) { (flag) in
                // When initial placement has been completed, place the view back in its correct position and fade in to alpha 1
                // This is a good facsimile to Mail on iOS
                let correctTopConstr = NSLayoutConstraint.init(item: resultsVC.view!, attribute: .top, relatedBy: .equal, toItem: self.view!, attribute: .top, multiplier: 1, constant: 0)
                resultsVC.view.removeConstraint(topConstr)
                topConstr.isActive = false
                correctTopConstr.isActive = true
               
                UIView.animate(withDuration: 0.3, animations: {
                    resultsVC.view.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    resultsVC.view.alpha = 1.0
                }) { (flag) in
                    self.resultsAreShown = true
                }
            }
        }
    }
    
    
}

extension TransactionsViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.sizeToFit()
        }
        // Animate result tableview controller to become visible
        animateResultsVC()

    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.sizeToFit()
        reloadHeader()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        resultsAreShown = false
        DispatchQueue.main.async {
            self.reloadHeader()
        }
    }
    
}


extension TransactionsViewController: SearchOptionDelegate {
  
    func didResumeSearch() {
        if #available(iOS 13.0, *) {
            searchController?.showsSearchResultsController = true
        }
    }
            
    @available(iOS 13.0, *)
    func didSelectSearchOption(option: TransactionSearchSuggestion) {
        guard let searchController = searchController as? TokenSearchController else {
            return
        }
        // First, add token to sarchfield
        searchController.searchBar.addToken(token: option.searchToken, for: option.predicate)
        
        // Then, Update search results
        searchPredicate = searchController.searchBar.completePredicate()

        // Manually update header view
        reloadHeader()
        
        // Last, Make result vc transparent and show partial search results
        searchController.showsSearchResultsController = false
    }
    
    @available(iOS 13.0, *)
    func textChanged() {
        guard let searchController = searchController as? TokenSearchController else {
            return
        }

        // Update search results
        searchPredicate = searchController.searchBar.completePredicate()
        
        // Manually update header view
        reloadHeader()
    }
    
}

extension TransactionsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let sarchText = searchController.searchBar.text {
            searchFilter = sarchText
        }
    }
    
    
}
