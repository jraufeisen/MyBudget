//
//  OnboardingBudgetTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 19.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

protocol OnboardingBudgetTableViewCellDelegate {
    func didAssignMoney(money: Money, to category: String)
}

// MARK: - OnboardingBudgetTableViewCell
class OnboardingBudgetTableViewCell: UITableViewCell {

    var delegate: OnboardingBudgetTableViewCellDelegate?
    
    static let Identifier: String = "OnboardingBudgetTableViewCell"
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!

    override func awakeFromNib() {
        selectionStyle = .none
        
        let keyboard = MoneyKeyboard.init(outputView: moneyTextField, startingWith: 0)
        keyboard.delegate = self
        moneyTextField.inputView = keyboard
        
        if #available(iOS 13.0, *) {
            backgroundColor = .systemGroupedBackground
            iconImageView.tintColor = .label
        }
    }
    
}

// MARK: - OnboardingBudgetTableViewCell
extension OnboardingBudgetTableViewCell: MoneyKeyBoardDelegate {
    
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        moneyTextField.resignFirstResponder()

        guard let category = accountLabel.text else {
            return
        }
        delegate?.didAssignMoney(money: keyboard.moneyEntered(), to: category)
    }
    
}
