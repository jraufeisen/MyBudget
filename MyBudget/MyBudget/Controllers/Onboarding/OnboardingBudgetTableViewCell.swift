//
//  OnboardingBudgetTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 19.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class OnboardingBudgetTableViewCell: UITableViewCell {

    static let Identifier: String = "OnboardingBudgetTableViewCell"
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!

    override func awakeFromNib() {
        selectionStyle = .none
        
        let keyboard = MoneyKeyboard.init(outputView: moneyTextField, startingWith: 0)
        keyboard.delegate = self
        moneyTextField.inputView = keyboard
        
    }
}

extension OnboardingBudgetTableViewCell: MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        moneyTextField.resignFirstResponder()
    }
}
