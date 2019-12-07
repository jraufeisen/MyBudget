//
//  EditNameTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 26.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class EditNameTableViewCell: UITableViewCell {

    static let Identifier = "EditNameTableViewCell"

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
        textfield.delegate = self
        if #available(iOS 13.0, *) {
            symbolImageView.image = UIImage.init(systemName: "text.justify") // SF symbols only available since iOS 13
        } else {
            symbolImageView.image = nil
        }
    }

    func selectedName() -> String? {
        return textfield.text
    }
    
}

// MARK: - UITextFieldDelegate
extension EditNameTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
