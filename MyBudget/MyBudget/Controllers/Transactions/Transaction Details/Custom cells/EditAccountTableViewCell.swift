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
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var symbolBackgroundView: RoundedCornerView!
    
    var colorStyle: EditTransactionDetailsCellStyles = .gray {
        didSet {
            symbolImageView.tintColor = colorStyle.primaryColor()
            symbolBackgroundView.backgroundColor = colorStyle.secondaryColor()
        }
    }
    
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
        
        if #available(iOS 13.0, *) {
            symbolImageView.image = UIImage.init(systemName: "creditcard") // SF symbols only available since iOS 13
        } else {
            symbolImageView.image = nil
        }
        
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
