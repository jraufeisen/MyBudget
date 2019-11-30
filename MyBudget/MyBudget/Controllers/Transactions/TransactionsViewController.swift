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
    private func updateSearchResults() {
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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFilter = "" // No filter at start
        
        let resultsVC = TransactionSearchTableViewController.instantiate()
        let searchController = UISearchController.init(searchResultsController: resultsVC)
        searchController.searchResultsUpdater = resultsVC
        searchController.searchBar.backgroundColor = .clear
        extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 13.0, *) {
            searchController.automaticallyShowsSearchResultsController = true
           // searchController.automaticallyShowsScopeBar = true
           // searchController.searchBar.scopeButtonTitles = ["A"]
        }
       // searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.delegate = self

        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateModel), name: ModelChangedNotification, object: nil)

        // Update transaction data, when the view is loaded for the first time
        // This is necessary, because in other view controllers, the user might change transaction data at runtime (e.g. add another transaction)
        // And at this point of change, this VC has not been a registered observer of the ModelChangedNotification
        updateModel()
    }
}

extension TransactionsViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
//        searchController.view.sizeToFit()
  //      searchController.searchResultsController?.view.isHidden = false
    //    navigationController?.navigationBar.sizeToFit()

    }
    
    func presentSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.sizeToFit()
    }
    func didPresentSearchController(_ searchController: UISearchController) {
       // searchController.view.sizeToFit()
        searchController.searchResultsController?.view.isHidden = false
        self.navigationController?.navigationBar.sizeToFit()
      //  navigationController?.navigationBar.layer.removeAllAnimations()
    }
}
