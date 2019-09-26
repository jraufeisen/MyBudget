//
//  EditMoneyTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 26.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

class EditMoneyTableViewCell: UITableViewCell {

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(for money: Money) {
        textfield.text = ""
        let keyboard = MoneyKeyboard.init(outputView: textfield, startingWith: money.minorUnits)
        keyboard.delegate = self
        textfield.inputView = keyboard
    }
    
}

extension EditMoneyTableViewCell: MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        textfield.resignFirstResponder()
    }
    
    
}
