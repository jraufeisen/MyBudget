//
//  OnboardingAccountTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 22.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

protocol OnboardingAccountObserver {
    func accountsChanged()
}

// MARK: - OnboardingAccountTableViewController
class OnboardingAccountTableViewController: UIViewController {

    var accounts = [OnboardingAccountViewable]() {
        didSet {
            delegate?.accountsChanged()
        }
    }
    
    var delegate: OnboardingAccountObserver?
    
    @IBOutlet weak var accountTableView: UITableView!
            
}

// MARK: - UITableViewDataSource
extension OnboardingAccountTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingAccountTableViewCell.Identifier) as! OnboardingAccountTableViewCell
        let accountViewable = accounts[indexPath.row]
        cell.iconImageView.image = accountViewable.icon
        cell.leftLabel.text = accountViewable.name
        cell.rightLabel.text = "\(accountViewable.money)"
        return cell
    }

}

// MARK: - UITableViewDelegate
extension OnboardingAccountTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            accounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}

// MARK: - OnboardingNewAccountDelegate
extension OnboardingAccountTableViewController: OnboardingNewAccountDelegate {
    
    func addNewAccount(name: String, money: Money) {
        let newAccount = OnboardingAccountViewable()
        newAccount.name = name
        newAccount.money = money
        newAccount.icon = #imageLiteral(resourceName: "Big Credit Card")
        accounts.insert(newAccount, at: 0)
        accountTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
    }
    
}
