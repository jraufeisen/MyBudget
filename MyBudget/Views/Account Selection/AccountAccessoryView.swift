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



class AccountAccessoryView: UITableView {
    
    var accountCreationDelegate: AccountCreationDelegate?
    
    private var outputView: UIKeyInput?
    
    init(outputView: UIKeyInput?, delegate: AccountCreationDelegate?, color: UIColor?) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50), style: .plain)

        self.backgroundColor = color
        self.accountCreationDelegate = delegate
        self.outputView = outputView
        
        self.dataSource = self
        self.isScrollEnabled = false
        register(UINib.init(nibName: "NewAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "newAccountCell")
    }
    
    
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}


extension AccountAccessoryView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newAccountCell") as? NewAccountCell else {
            fatalError("new account cell not found")
        }
        
        // All bgColor configuration moves here
        cell.accountTextField?.backgroundColor = .clear;
        cell.backgroundColor = .clear
        cell.accountTextField?.textColor = .white
        cell.accountTextField.delegate = self
        cell.accountTextField?.font = UIFont.boldSystemFont(ofSize: 18)
        
        return cell
    }
    
}


protocol AccountCreationDelegate {
    func createAccount(name: String)
}

extension AccountAccessoryView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let newAccount = textField.text else {
            return true
        }
        if newAccount.isEmpty == false {
            accountCreationDelegate?.createAccount(name: newAccount)
        }
        return true
    }
}
