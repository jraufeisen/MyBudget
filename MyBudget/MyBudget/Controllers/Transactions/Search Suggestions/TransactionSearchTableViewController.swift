//
//  TransactionSearchTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 29.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

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
        let icon = #imageLiteral(resourceName: "euro.png").withTintColor(.incomeColor)
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: "Income", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? IncomeTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Income"))
        

        return suggestion
    }
    
    static func expense() -> TransactionSearchSuggestion {
        let icon = #imageLiteral(resourceName: "euro.png").withTintColor(.expenseColor)
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: "Expense", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? ExpenseTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Expense"))
        return suggestion
    }

    static func transfer() -> TransactionSearchSuggestion {
        let icon = #imageLiteral(resourceName: "euro.png").withTintColor(.transferColor)
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: "Transfer", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? TransferTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Transfer"))
        return suggestion
    }
    
    static func thisMonth() -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "This Month", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date.firstDayOfCurrentMonth() == Date().firstDayOfCurrentMonth()
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "This Month"))

        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon

        return suggestion
    }

    static func nameContaining(part: String) -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Name contains \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.description.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Name contains \(part)"))
        
        let icon = UIImage.init(systemName: "magnifyingglass")
        suggestion.icon = icon

        return suggestion
    }
    
    static func dateBefore(date: Date) -> TransactionSearchSuggestion {
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Date before \(localizedDate)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date <= date
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Date before \(localizedDate)"))
        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon
        
        return suggestion
    }

    static func dateAfter(date: Date) -> TransactionSearchSuggestion {
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Date after \(localizedDate)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date >= date
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Date after \(localizedDate)"))
        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon
        return suggestion
    }

    static func accountContains(part: String) -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Account contains \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? IncomeTransaction {
                return tx.account.contains(part)
            } else if let tx = evaluatedObject as? ExpenseTransaction {
                return tx.account.contains(part)
            } else if let tx = evaluatedObject as? TransferTransaction {
                return tx.toAccount.contains(part) || tx.fromAccount.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Account contains \(part)"))
        let icon = UIImage.init(systemName: "magnifyingglass")
        suggestion.icon = icon
        return suggestion
    }
    
    static func tagContains(part: String) -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Tag named \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.tags.contains { (tag) -> Bool in
                    return tag.contains(part)
                }
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Tag named \(part)"))
        let icon = UIImage.init(systemName: "tag")
        suggestion.icon = icon
        return suggestion
    }
    
    static func budgetCategoryContains(part: String) -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Budget category named \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? ExpenseTransaction {
                return tx.category.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Budget category named \(part)"))
        let icon = UIImage.init(systemName: "bag")
        suggestion.icon = icon
        return suggestion
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

        let categoryContains = TransactionSearchSuggestion.budgetCategoryContains(part: partialString)
        detailedSearchSuggestions.append(categoryContains)
        let accountContains = TransactionSearchSuggestion.accountContains(part: partialString)
        detailedSearchSuggestions.append(accountContains)
        let tagContains = TransactionSearchSuggestion.tagContains(part: partialString)
        detailedSearchSuggestions.append(tagContains)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.register(UINib(nibName: "SearchSuggestionTableViewCell", bundle: nil), forCellReuseIdentifier: SearchSuggestionTableViewCell.Identifier)
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
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchText.isEmpty {
            return simpleSearchSuggestions.count
        } else {
            return detailedSearchSuggestions.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchSuggestionTableViewCell.Identifier) as! SearchSuggestionTableViewCell
        
        if searchText.isEmpty {
            let searchSugestion = simpleSearchSuggestions[indexPath.row]
            cell.label.text = searchSugestion.text
            cell.iconImageView.image = searchSugestion.icon
        } else {
            let searchSugestion = detailedSearchSuggestions[indexPath.row]
            cell.label.text = searchSugestion.text
            cell.iconImageView.image = searchSugestion.icon
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
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
