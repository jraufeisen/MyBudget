//
//  MoneyKeyboard.swift
//  MyBudget
//
//  Created by Johannes on 26.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

protocol MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard)
}

class MoneyKeyboard: APNumberPad {

    var delegate: MoneyKeyBoardDelegate?
    
    
    ///Saves sequence of entered digits. Only allows editing in this range of characters
    private var characterSequence = ""
    /// Text which is currently displayed on screen. This includes money formatting and is autmatically created.
    private var currentlyDisplayed = ""

    
    private var outputView: UIKeyInput?
    private var readyToTakeInput = false
    
    /// Startng with minorUnits
    init(outputView: UIKeyInput, startingWith: Int = 0) {
        //super.init()
        //super.init(delegate: self)
        super.init(delegate: nil , numberPadStyleClass: nil)
    
        leftFunctionButton.setTitle("Done", for: .normal)
        leftFunctionButton.titleLabel?.adjustsFontSizeToFitWidth = true

        self.outputView = outputView
        
        if startingWith == 0 {
            characterSequence = ""
        } else {
            characterSequence = "\(startingWith)"
        }
        insertInitialText()
    }

    private func insertInitialText() {
        outputView?.addTextAnimated(text: currentMoneyText(), completion: {
            self.currentlyDisplayed = self.currentMoneyText()
            self.readyToTakeInput = true
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func numberButtonAction(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return
        }
        guard readyToTakeInput else {return}
        if characterSequence.isEmpty && buttonText == "0" {
            // Ignore leading zeros
            return
        }
        
        characterSequence += buttonText
        updateOutputText()
    }

    
    func moneyEntered() -> Money {
        let pureDigits = characterSequence.onlyDigits()

        guard !pureDigits.isEmpty else {
            return 0
        }
        guard let minorUnits = Int(pureDigits) else {
            fatalError("Keyboard was not able to enter money in correct format")
        }
        
        return Money.init(minorUnits: minorUnits)
    }
    
    
    func animateDown() {
        UIView.animate(withDuration: 0.2) {
            self.center = CGPoint.init(x: self.center.x, y: UIScreen.main.bounds.height + self.frame.size.height/2)
        }
    }
    func animateUp() {
        UIView.animate(withDuration: 0.2) {
            self.center = CGPoint.init(x: self.center.x, y: 200)
        }
    }
    override func clearButtonAction() {
        guard !characterSequence.isEmpty else {
            return
        }
        characterSequence.removeLast()
        updateOutputText()
    }
    
    /// Function button serves as "Done" button in this subclass. Calls delegate method.
    override func functionButtonAction(_ sender: Any) {
       self.delegate?.moneyKeyboardPressedDone(keyboard: self)

    }
    
    private func updateOutputText() {
        deleteMoneyText()
        insertMoneyText()
    }
    
    private func deleteMoneyText() {
        for _ in 0..<currentlyDisplayed.count {
            outputView?.deleteBackward()
        }
    }

  
    private func currentMoneyText() -> String {
        return "\(moneyEntered())" // Automatically return locaized money value
    }
    
    private func insertMoneyText() {
        outputView?.insertText(currentMoneyText())
        currentlyDisplayed = currentMoneyText()
    }
    
}


