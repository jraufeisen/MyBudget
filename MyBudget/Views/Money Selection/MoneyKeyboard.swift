//
//  MoneyKeyboard.swift
//  MyBudget
//
//  Created by Johannes on 26.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

protocol MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard)
}

class MoneyKeyboard: APNumberPad {

    var delegate: MoneyKeyBoardDelegate?
    
    
    ///Saves sequence of entered digits. Only allows editing in this range of characters
    private var characterSequence = ""
    private var currentlyDisplayed = ""

    
    private var outputView: UIKeyInput?
    
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
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func numberButtonAction(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return
        }
        characterSequence += buttonText
        updateOutputText()
    }

    
    func moneyEntered() -> Money {
        let pureDigits = currentlyDisplayed.onlyDigits()
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
        if characterSequence.count <= 2 {
            var fillUpZeros = ""
            var i = 2 - characterSequence.count
            while i > 0 {
                fillUpZeros += "0"
                i -= 1
            }
            
            return "00," + characterSequence + fillUpZeros + "€"
        } else {
            let decimalBegin = characterSequence.index(characterSequence.endIndex, offsetBy: -2)
            let decimalEnd = characterSequence.index(characterSequence.endIndex, offsetBy: -1)
            let cents = String(characterSequence[decimalBegin...decimalEnd])
            var units = String(characterSequence[characterSequence.startIndex..<decimalBegin])
            if units.count == 1 {
                units = "0" + units
            }
            
            
            return units + "," + cents + "€"
        }
    }
    
    private func insertMoneyText() {
        outputView?.insertText(currentMoneyText())
        currentlyDisplayed = currentMoneyText()
    }
    
}


