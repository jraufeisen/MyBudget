//
//  DiaryTextView.swift
//  MyBudget
//
//  Created by Johannes on 25.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

// MARK: - DiaryTextView
class DiaryTextView: UITextView {
    
    /// Initliazie with empty diary
    private var diaryEntry = DiaryEntry()
    
    /// Current entry index
    private var entryIndex = -1
    
    /// Stores the earliest possible position at which the diary textview is currently modifiable. Applies to the current diary entry only.
    private var keyboardInputBeginPosition: String.Index?
    
    var diaryDelegate: DiaryDelegate?
    
    /// Configure diary entry for given provider.
    public func configure(diaryProvider: DiaryProvider) {
        self.delegate = self
        diaryEntry = diaryProvider.diaryEntry()
        entryIndex = -1
        nextDiaryEntry()
        tintColor = .white
    }
   
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false //Disable magnifier, but keep cursor.
    }
    
    /// - Returns: True, if there is another entry type that can be entered. False otherwise.
    private func nextDiaryEntryIsAvailable() -> Bool {
        return entryIndex < diaryEntry.count-1
    }
    
    /// Displays the next data entry for the current diary.
    public func nextDiaryEntry() {
        guard nextDiaryEntryIsAvailable() else {
            _ = resignFirstResponder()
            diaryDelegate?.didFinishDiaryEntry()
            return
        }
        entryIndex += 1
        let currentEntry = diaryEntry[entryIndex]
        // Display new text
        // Special case: If we ask for the date in the beginning, we set the default value to today and skip the initial data entry
        if entryIndex == 0 && currentEntry.entryType == .date {
            text += "Today"
            nextDiaryEntry()
            return
        }
        
        addTextAnimated(text: currentEntry.text, timeBetweenCharacters: 0.05) {
            self.keyboardInputBeginPosition = self.text.endIndex
            // Ask for new input depending on the entry type
            self.configureInput(type: currentEntry.entryType)
        }
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
            newAccountView.accountCreationDelegate = accountView
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
            newCategoryView.categoryCreationDelegate = categoryView
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
    
    /// No copy, paste, select on this textview
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    /// Do not change position of cursor. Keep cursor at end of text
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        return endOfDocument
    }
    
}

// MARK: - UITextViewDelegate
extension DiaryTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Do not print a new line when entered by the keyboard, instead finish data entry
        if text == "\n", let startIndex = keyboardInputBeginPosition {
            let currentlyEnteredByKeyboard = String(self.text[startIndex...])
            guard !currentlyEnteredByKeyboard.isEmpty else {return false} // No input is not valid
            
            diaryDelegate?.didEnterDiaryPair(index: entryIndex, value: currentlyEnteredByKeyboard) // Forward entered text to delegate
            finishDataEntry()                   // Show next keyboard
            return false
        }

        // Only allow editing after keyboardInputBeginPosition
        if let startIndex = keyboardInputBeginPosition {
            let forbiddenRange = NSRange.init(..<startIndex, in: self.text)
            if range.intersection(forbiddenRange) != nil {
                if self.text.endIndex > startIndex {
                    self.text = String(self.text[..<startIndex])
                }
                return false
            }
        }
        return true
    }
    
    @objc private func finishDataEntry() {
        _ = resignFirstResponder()
        nextDiaryEntry()
    }
    
}

// MARK: - AccountSelectDelegate
extension DiaryTextView: AccountSelectDelegate {
    
    func didSelectAccount(account: String) {
        diaryDelegate?.didEnterDiaryPair(index: entryIndex, value: account)
        finishDataEntry()
    }
    
}

// MARK: - CategorySelectDelegate
extension DiaryTextView: CategorySelectDelegate {
    
    func didSelectCategory(category: String) {
        diaryDelegate?.didEnterDiaryPair(index: entryIndex, value: category)
        finishDataEntry()
    }
    
}

// MARK: - MoneyKeyBoardDelegate
extension DiaryTextView: MoneyKeyBoardDelegate {
    
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        diaryDelegate?.didEnterDiaryPair(index: entryIndex, value: keyboard.moneyEntered())
        finishDataEntry()
    }
    
}
