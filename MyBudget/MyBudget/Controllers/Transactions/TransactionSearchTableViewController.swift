//
//  TransactionSearchTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 29.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import SwiftDate

protocol SearchOptionDelegate {
    @available(iOS 13.0, *)
    func didSelectSearchOption(option: TransactionSearchSuggestion)
    @available(iOS 13.0, *)
    func textChanged()
    func didResumeSearch()
}

@available(iOS 13.0, *)
class TransactionSearchSuggestion {
    var icon: UIImage?
    var text: String
    
    /// Predicate to evaluate with an object of type Transaction
    var predicate: NSPredicate
    var searchToken: UISearchToken
    
    init(icon: UIImage?, text: String, predicate: NSPredicate, searchToken: UISearchToken) {
        self.icon = icon
        self.text = text
        self.predicate = predicate
        self.searchToken = searchToken
    }
    
    static func income() -> TransactionSearchSuggestion {
        return TransactionSearchSuggestion.init(icon: nil, text: "Income", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? IncomeTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Income"))
    }
    
    static func expense() -> TransactionSearchSuggestion {
        return TransactionSearchSuggestion.init(icon: nil, text: "Expense", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? ExpenseTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Expense"))
    }

    static func transfer() -> TransactionSearchSuggestion {
        return TransactionSearchSuggestion.init(icon: nil, text: "Transfer", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? TransferTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Transfer"))
    }
    
    static func thisMonth() -> TransactionSearchSuggestion {
        return TransactionSearchSuggestion.init(icon: nil, text: "This Month", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date.firstDayOfCurrentMonth() == Date().firstDayOfCurrentMonth()
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "This Month"))
    }

    static func nameContaining(part: String) -> TransactionSearchSuggestion {
        return TransactionSearchSuggestion.init(icon: nil, text: "Name contains \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.description.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Name contains \(part)"))
    }
    
    static func dateBefore(date: Date) -> TransactionSearchSuggestion {
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        return TransactionSearchSuggestion.init(icon: nil, text: "Date before \(localizedDate)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date <= date
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Date before \(localizedDate)"))
    }

    static func dateAfter(date: Date) -> TransactionSearchSuggestion {
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        return TransactionSearchSuggestion.init(icon: nil, text: "Date after \(localizedDate)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date >= date
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Date after \(localizedDate)"))
    }

    static func accountContains(part: String) -> TransactionSearchSuggestion {
        return TransactionSearchSuggestion.init(icon: nil, text: "Account contains \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? IncomeTransaction {
                return tx.account.contains(part)
            } else if let tx = evaluatedObject as? ExpenseTransaction {
                return tx.account.contains(part)
            } else if let tx = evaluatedObject as? TransferTransaction {
                return tx.toAccount.contains(part) || tx.fromAccount.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Account contains \(part)"))
    }
    
}


@available(iOS 13.0, *)
class TransactionSearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static func instantiate() -> TransactionSearchTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TransactionSearchTableViewController") as! TransactionSearchTableViewController
        return vc
    }

    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SearchOptionDelegate?

    var simpleSearchSuggestions: [TransactionSearchSuggestion] = [.income(), .expense(), .transfer(), .thisMonth()]
    var detailedSearchSuggestions = [TransactionSearchSuggestion]()
    
    private func loadDetailedSearchSuggestions(partialString: String) {
        detailedSearchSuggestions.removeAll()

        let nameContains = TransactionSearchSuggestion.nameContaining(part: partialString)
        detailedSearchSuggestions.append(nameContains)
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.current
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        
        if let date = dateformatter.date(from: partialString) {
            let dateBefore = TransactionSearchSuggestion.dateBefore(date: date)
            detailedSearchSuggestions.append(dateBefore)

            let dateAfter = TransactionSearchSuggestion.dateAfter(date: date)
            detailedSearchSuggestions.append(dateAfter)
        }
        
        let accountContains = TransactionSearchSuggestion.accountContains(part: partialString)
        detailedSearchSuggestions.append(accountContains)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
    }

    // MARK: - Table view data source

    private var searchText = "" {
        didSet {
            loadDetailedSearchSuggestions(partialString: searchText)
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchText.isEmpty {
            return 1
        }
        
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchText.isEmpty {
            return "Search suggestions"
        } else {
            return "Detailed Search"
           // let searchModes = ["", "Date", "Accounts"]
        //return searchModes[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchText.isEmpty {
            return simpleSearchSuggestions.count
        } else {
            //let searchModeSizes = [1, 2, 1]
            return detailedSearchSuggestions.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if searchText.isEmpty {
            let searchSugestions = simpleSearchSuggestions[indexPath.row]
            cell.textLabel?.text = searchSugestions.text
        } else {
            let searchSugestions = detailedSearchSuggestions[indexPath.row]
            cell.textLabel?.text = searchSugestions.text
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I selected a special search option")
        
        // Remove "real text" from sarchbar
        // Add "search tag" into the searchbar
        // Communcate to delegate: We selected a search option, Some predicate will be added
        if searchText.isEmpty {
            let selectedSearchSuggestion = simpleSearchSuggestions[indexPath.row]
            delegate?.didSelectSearchOption(option: selectedSearchSuggestion)
        } else {
            let selectedSearchSuggestion = detailedSearchSuggestions[indexPath.row]
            delegate?.didSelectSearchOption(option: selectedSearchSuggestion)
        }
        
        
    }
}

@available(iOS 13.0, *)
extension TransactionSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        delegate?.textChanged()
        
        if let text = searchController.searchBar.text {
            if searchText.isEmpty && !text.isEmpty {
                delegate?.didResumeSearch()
            }
            searchText = text
        }
    }
}
