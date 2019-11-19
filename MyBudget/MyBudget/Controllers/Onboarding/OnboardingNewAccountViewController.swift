//
//  OnboardingNewAccountViewController.swift
//  MyBudget
//
//  Created by Johannes on 19.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

protocol OnboardingNewAccountDelegate {
    func addNewAccount(name: String, money: Money)
}

class OnboardingNewAccountViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!

    @IBOutlet weak var textFieldsBackground: UIView!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    
    var delegate: OnboardingNewAccountDelegate?
    
    internal static func instantiate() -> OnboardingNewAccountViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingNewAccountViewController") as! OnboardingNewAccountViewController
        return vc
    }

    @IBAction func pressedCreateAccountButton() {
        guard let accountName = accountNameTextField.text else {
            return
        }
        guard let keyboard = moneyTextField.inputView as? MoneyKeyboard else {
            return
        }
        let money = keyboard.moneyEntered()
        guard accountName.isEmpty == false else {
            return
        }
        
        dismiss(animated: true) {
            self.delegate?.addNewAccount(name: accountName, money: money)
        }
    }
    

    override func viewDidLoad() {
        
        // Adjust button
        createAccountButton.backgroundColor = .blueActionColor
        createAccountButton.layer.cornerRadius = 10
        createAccountButton.layer.shadowColor = createAccountButton.backgroundColor?.cgColor
        createAccountButton.layer.shadowRadius = 3
        createAccountButton.layer.shadowOffset = CGSize.init(width: 2, height: -2)
        createAccountButton.layer.shadowOpacity = 0.5

        // Adjust textfield backgrounds
        if #available(iOS 13.0, *) {
            textFieldsBackground.backgroundColor = .systemGroupedBackground
        } else {
            textFieldsBackground.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
        }
        
        accountNameTextField.delegate = self
        moneyTextField.delegate = self
        
        let keyboard = MoneyKeyboard.init(outputView: self.moneyTextField, startingWith: 0)
        keyboard.delegate = self
        moneyTextField.inputView = keyboard

        
        accountNameTextField.becomeFirstResponder()
    }
    

    
}

extension OnboardingNewAccountViewController: UITextFieldDelegate, MoneyKeyBoardDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == accountNameTextField {
            moneyTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        moneyTextField.resignFirstResponder()
    }
    
}
