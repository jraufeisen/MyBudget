//
//  AccountTableView.swift
//  MyBudget
//
//  Created by Johannes on 24.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit



class NewAccountCell: UITableViewCell {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountTextField: UITextField!
}

class ExistingAccountCell: UITableViewCell {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
}

protocol AccountSelectDelegate {
    func didSelectAccount(account: String)
}

class AccountTableView: UITableView {
    let accounts = ["Cash", "Checkings", "Savings"]

    var accountDelegate: AccountSelectDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self

        register(UINib.init(nibName: "NewAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "newAccountCell")
        register(UINib.init(nibName: "ExistingAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "existingAccountCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}


extension AccountTableView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newAccountCell") as? NewAccountCell else {
                fatalError("new account cell not found")
            }
            // All bgColor configuration moves here
            cell.accountTextField?.backgroundColor = .clear;
            cell.backgroundColor = .clear
            cell.accountTextField?.textColor = .white

            cell.accountTextField?.text = "New account"
            cell.accountTextField?.font = UIFont.boldSystemFont(ofSize: 18)
            return cell
        }
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "existingAccountCell") as? ExistingAccountCell else {
            fatalError("existing account cell not found")
        }
        
        
        // All bgColor configuration moves here
        cell.accountLabel?.backgroundColor = .clear;
        cell.backgroundColor = .clear
        cell.accountLabel?.textColor = .white
        cell.accountLabel?.text = accounts[indexPath.row-1]

        
        return cell
    }
    
}

extension AccountTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let selectedAccount = accounts[indexPath.row-1]
        accountDelegate?.didSelectAccount(account: selectedAccount)

    }
}
