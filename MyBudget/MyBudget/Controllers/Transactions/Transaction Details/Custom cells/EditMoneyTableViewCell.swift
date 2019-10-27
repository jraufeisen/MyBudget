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

    static let Identifier = "EditMoneyTableViewCell"
    
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
        
        if #available(iOS 13.0, *) {
            symbolImageView.image = UIImage.init(systemName: "eurosign.circle") // SF symbols only available since iOS 13
        } else {
            symbolImageView.image = #imageLiteral(resourceName: "add.png").withRenderingMode(.alwaysTemplate)
        }
        
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
    
    func selectedMoney() -> Money {
        guard let keyboard = textfield.inputView as? MoneyKeyboard else {
            return 0
        }
        
        return keyboard.moneyEntered()
    }
    
}

extension EditMoneyTableViewCell: MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        textfield.resignFirstResponder()
    }
    
    
}
