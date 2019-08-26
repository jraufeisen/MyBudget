//
//  TransactionsViewController.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

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
        
        if let expenseTx = tx as? ExpenseTransaction  {
            cell.accountLabel.text = expenseTx.account
            cell.moneyLabel.textColor = .expenseColor
            let localizedDateString = DateFormatter.localizedString(from: expenseTx.date, dateStyle: .medium, timeStyle: .none)
            cell.dateLabel.text = localizedDateString
        }

        if let incomeTx = tx as? IncomeTransaction {
            cell.accountLabel.text = incomeTx.account
            cell.moneyLabel.textColor = .incomeColor
            let localizedDateString = DateFormatter.localizedString(from: incomeTx.date, dateStyle: .medium, timeStyle: .none)
            cell.dateLabel.text = localizedDateString
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }

    @IBOutlet weak var tableView: UITableView!
    
    let search = UISearchController.init(searchResultsController: nil)

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFilter = "" // No filter at start
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search all transactions"
        search.searchBar.sizeToFit()

        navigationItem.searchController = search

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateModel), name: ModelChangedNotification, object: nil)
    }
}

extension TransactionsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        self.searchFilter = searchText
    }
    
    
}
