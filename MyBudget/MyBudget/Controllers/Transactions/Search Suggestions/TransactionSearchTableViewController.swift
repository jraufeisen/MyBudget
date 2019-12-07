//
//  TransactionSearchTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 29.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

// MARK: - SearchOptionDelegate
protocol SearchOptionDelegate {
    @available(iOS 13.0, *)
    func didSelectSearchOption(option: TransactionSearchSuggestion)
    @available(iOS 13.0, *)
    func textChanged()
    func didResumeSearch()
}

// MARK: - TransactionSearchTableViewController
@available(iOS 13.0, *)
class TransactionSearchTableViewController: UIViewController {

    static func instantiate() -> TransactionSearchTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TransactionSearchTableViewController") as! TransactionSearchTableViewController
        return vc
    }

    @IBOutlet weak var tableView: UITableView!

    var delegate: SearchOptionDelegate?
    var simpleSearchSuggestions: [TransactionSearchSuggestion] = [.income(), .expense(), .transfer(), .thisMonth()]
    var detailedSearchSuggestions = [TransactionSearchSuggestion]()
    
    private var searchText = "" {
        didSet {
            loadDetailedSearchSuggestions(partialString: searchText)
            tableView.reloadData()
        }
    }
    
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

}

// MARK: - UITableViewDataSource
@available(iOS 13.0, *)
extension TransactionSearchTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchText.isEmpty {
            return 1
        }
        return 1
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
    
}

// MARK: - UITableViewDataSource
@available(iOS 13.0, *)
extension TransactionSearchTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchText.isEmpty {
            return "Search suggestions"
        } else {
            return "Detailed Search"
        }
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

// MARK: - UISearchResultsUpdating
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
