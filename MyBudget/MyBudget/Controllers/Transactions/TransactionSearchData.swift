//
//  TransactionSearchData.swift
//  MyBudget
//
//  Created by Johannes on 29.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

protocol SearchOptionDelegate {
    func didSelectSearchOption()
}

class TransactionSearchData: NSObject, UITableViewDataSource, UITableViewDelegate {

    static let shared = TransactionSearchData()
    private override init() {}

    var delegate: SearchOptionDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Search Option 1"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectSearchOption()
    }
    
}
