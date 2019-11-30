//
//  TransactionSearchTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 29.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit


protocol SearchOptionDelegate {
    func didSelectSearchOption()
    func didResumeSearch()
}


class TransactionSearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static func instantiate() -> TransactionSearchTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TransactionSearchTableViewController") as! TransactionSearchTableViewController
        return vc
    }

    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SearchOptionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
    }

    // MARK: - Table view data source

    private var searchText = "" {
        didSet {
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchText.isEmpty {
            return 1
        }
        
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchText.isEmpty {
            return "Search suggestions"
        } else {
            let searchModes = ["", "Date", "Accounts"]
            return searchModes[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchText.isEmpty {
            return 4
        } else {
            let searchModeSizes = [1, 2, 1]
            return searchModeSizes[section]
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if searchText.isEmpty {
            let searchSugestions = ["All income transactions", "All expense transactions" ,"All transfer transactions", "All transactions this month"]
            cell.textLabel?.text = searchSugestions[indexPath.row]
        } else {
            cell.textLabel?.text = "Search for \(searchText)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I selected a special search option")
        
        // Remove "real text" from sarchbar
        // Add "search tag" into the searchbar
        // Communcate to delegate: We selected a search option, Some predicate will be added
        delegate?.didSelectSearchOption()
        
    }
}

extension TransactionSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            if searchText.isEmpty && !text.isEmpty {
                delegate?.didResumeSearch()
            }
            searchText = text
        }
    }
}
