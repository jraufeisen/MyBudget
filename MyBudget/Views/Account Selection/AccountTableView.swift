//
//  AccountTableView.swift
//  MyBudget
//
//  Created by Johannes on 24.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit




class ExistingAccountCell: UITableViewCell {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
}

protocol AccountSelectDelegate {
    func didSelectAccount(account: String)
}

class AccountTableView: UITableView {
    private let accounts = Model.shared.getAllAccountNames()
    private var accountDelegate: AccountSelectDelegate?
    private var outputView: UIKeyInput?
    
    
    init(outputView: UIKeyInput?, delegate: AccountSelectDelegate?, color: UIColor?) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2), style: .plain)
        self.backgroundColor = color
        self.accountDelegate = delegate
        self.outputView = outputView
        
        self.dataSource = self
        self.delegate = self
        
        autoresizingMask = .flexibleHeight // When used as inputview, this makes thei height be equal to standard keyboard height
        register(UINib.init(nibName: "ExistingAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "existingAccountCell")

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


extension AccountTableView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "existingAccountCell") as? ExistingAccountCell else {
            fatalError("existing account cell not found")
        }
        
        
        // All bgColor configuration moves here
        cell.accountLabel?.backgroundColor = .clear;
        cell.backgroundColor = .clear
        cell.accountLabel?.textColor = .white
        cell.accountLabel?.text = accounts[indexPath.row]
        
        return cell
    }
    
}

extension AccountTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAccount = accounts[indexPath.row]
        outputView?.insertText(selectedAccount)
        accountDelegate?.didSelectAccount(account: selectedAccount)
    }
}

