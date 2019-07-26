//
//  DiaryTextView.swift
//  MyBudget
//
//  Created by Johannes on 25.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

typealias DiaryEntry = [(text: String, entryType: EntryType)]


enum EntryType {
    case date
    case money
    case account
    case category
    case tags
    case description
}

protocol DiaryProvider {
    func diaryEntry() -> DiaryEntry
}

class DiaryTextView: UITextView {

    
    /// Initliazie with empty diary
    private var diaryEntry = DiaryEntry()
    
    /// Current entry index
    private var entryIndex = -1
    
    /// Configure diary entry for given provider.
    public func configure(diaryProvider: DiaryProvider) {
        self.delegate = self
        diaryEntry = diaryProvider.diaryEntry()
        entryIndex = -1
        nextDiaryEntry()
    }
    
    /// - Returns: True, if there is another entry type that can be entered. False otherwise.
    private func nextDiaryEntryIsAvailable() -> Bool {
        return entryIndex < diaryEntry.count-1
    }
    
    /// Displays the next data entry for the current diary.
    public func nextDiaryEntry() {
        guard nextDiaryEntryIsAvailable() else {
            _ = resignFirstResponder()
            return
        }
        entryIndex += 1
        let currentEntry = diaryEntry[entryIndex]
        // Display new text
        // Special case: If we ask for the date in the beginning, we set the default value to today and skip the initial data entry
        if entryIndex == 0 && currentEntry.entryType == .date {
            text = "Today"
            nextDiaryEntry()
            return
        }
        
        text += currentEntry.text
        
        
        // Ask for new input depending on the entry type
        configureInput(type: currentEntry.entryType)
    }



    private func transitionToInputView(view: UIView, accessoryView: UIView?) {
        inputView?.addSubview(view)
        if let access = accessoryView {
            inputView?.addSubview(access)
        }
        view.center = CGPoint.init(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height)
        accessoryView?.center = CGPoint.init(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height)

        UIView.animate(withDuration: 0.2, animations: {
            view.center = CGPoint.init(x: self.center.x, y: 200)

        }) { (flag) in
            self.inputView = view
            self.inputAccessoryView = accessoryView
            self.becomeFirstResponder()
        }
    }
    
    private func configureInput(type: EntryType) {

        switch type {
        case .account:
            let accountView = AccountTableView.init(outputView: self, delegate: self, color: superview?.backgroundColor)
            let newAccountView = AccountAccessoryView.init(outputView: self, delegate: nil, color: superview?.backgroundColor)
            transitionToInputView(view: accountView, accessoryView: newAccountView)
        case .date:
            let datePicker = UIDatePicker()
            transitionToInputView(view: datePicker, accessoryView: nil)
        case .money:
            let moneyKeyboard = MoneyKeyboard.init(outputView: self)
            moneyKeyboard.delegate = self
            self.inputView = moneyKeyboard // DO not animate this transition, cause its first most of the time
            self.becomeFirstResponder()
        case .category:
            let categoryView = CategoryTableView.init(outputView: self, delegate: self, color: superview?.backgroundColor)
            let newCategoryView = CategoryAccessoryView.init(outputView: self, delegate: nil, color: superview?.backgroundColor)
            transitionToInputView(view: categoryView, accessoryView: newCategoryView)
        case .tags:
            keyboardType = .default
            becomeFirstResponder()
        case .description:
            inputView = nil
            inputAccessoryView = nil
            keyboardType = .default
            becomeFirstResponder()
        }

    }
    
 
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
       
    }
    

    
}


extension DiaryTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            finishDataEntry()
            return false
        }
        
        return true
    }
    
    @objc private func finishDataEntry() {
        _ = resignFirstResponder()
        nextDiaryEntry()
    }
    
}

extension DiaryTextView: AccountSelectDelegate {
    func didSelectAccount(account: String) {
        finishDataEntry()
    }
}

extension DiaryTextView: CategorySelectDelegate {
    func didSelectCategory(category: String) {
        finishDataEntry()
    }
}

extension DiaryTextView: MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        finishDataEntry()
    }
}
