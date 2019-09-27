//
//  EditAccountTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 26.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class EditAccountTableViewCell: UITableViewCell {

    static let Identifier = "EditAccountTableViewCell"

    @IBOutlet weak var textfield: UITextField!
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return textfield.becomeFirstResponder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        let accountView = AccountTableView.init(outputView: textfield, delegate: self, color: superview?.backgroundColor)
        textfield.inputView = accountView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selectedAccount() -> String? {
        return textfield.text
    }
}

extension EditAccountTableViewCell: AccountSelectDelegate {
    func didSelectAccount(account: String) {
        textfield.text = account
        textfield.resignFirstResponder()
    }
    
}
