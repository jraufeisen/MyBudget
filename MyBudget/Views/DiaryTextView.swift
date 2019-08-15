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


protocol DiaryDelegate {
    func didFinishDiaryEntry()
    func didEnterDiaryPair(index: Int, value: Any)
}


class DiaryTextView: UITextView {

    
    /// Initliazie with empty diary
    private var diaryEntry = DiaryEntry()
    
    /// Current entry index
    private var entryIndex = -1
    
    /// Keeps track of all characters entered via the keyboard and only allows editing within this range
    private var currentlyEntteredByKeyboard = ""

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
        //Todo: allow taps on keywords to bring up keyboards again
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
        
       // text += currentEntry.text
        addTextAnimated(text: currentEntry.text) {
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


extension DiaryTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Do not print a new line, instead finish data entry
        if text == "\n" {
            diaryDelegate?.didEnterDiaryPair(index: entryIndex, value: currentlyEntteredByKeyboard) // Forward entered text to delegate
            currentlyEntteredByKeyboard = ""    // Reset counter
            finishDataEntry()                   // Show next keyboard
            return false
        }

        // Only allow character deletion if we are in the allowed scope
        if text == "" {
            if range.length > currentlyEntteredByKeyboard.count {
                self.text.removeLast(currentlyEntteredByKeyboard.count)
                currentlyEntteredByKeyboard = ""
                return false
            }
            
            if currentlyEntteredByKeyboard.isEmpty {
                return false
            }

            if range.length > 1 {
                currentlyEntteredByKeyboard.removeLast(1)
                self.text.removeLast(1)
                return false
            } else {
                currentlyEntteredByKeyboard.removeLast(1)
            }
            return true
        } else {
            currentlyEntteredByKeyboard += text
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
        diaryDelegate?.didEnterDiaryPair(index: entryIndex, value: account)
        finishDataEntry()
    }
}

extension DiaryTextView: CategorySelectDelegate {
    func didSelectCategory(category: String) {
        diaryDelegate?.didEnterDiaryPair(index: entryIndex, value: category)
        finishDataEntry()
    }
}

extension DiaryTextView: MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        diaryDelegate?.didEnterDiaryPair(index: entryIndex, value: keyboard.moneyEntered())
        finishDataEntry()
    }
}
