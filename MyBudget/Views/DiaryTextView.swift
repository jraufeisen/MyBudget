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
            resignFirstResponder()
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

    
    private func configureInput(type: EntryType) {
        inputView = nil
        inputAccessoryView = nil
        switch type {
        case .account:
            inputView = AccountTableView.init(outputView: self, delegate: self, color: superview?.backgroundColor)
            inputAccessoryView = AccountAccessoryView.init(outputView: self, delegate: nil, color: superview?.backgroundColor)
            becomeFirstResponder()
        case .date:
            inputView = UIDatePicker()
            becomeFirstResponder()
        case .money:
            let iv = APNumberPad.init(delegate: self, numberPadStyleClass: nil)
           // [numberPad.leftFunctionButton setTitle:@"Func" forState:UIControlStateNormal];
           // numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            iv.leftFunctionButton.setTitle("Done", for: .normal)
            iv.leftFunctionButton.titleLabel?.adjustsFontSizeToFitWidth = true
            //iv.clearButton.setTitle("test", for: .normal)
            inputView = iv
            becomeFirstResponder()
        case .category:
            inputView = CategoryTableView.init(outputView: self, delegate: self, color: superview?.backgroundColor)
            inputAccessoryView = CategoryAccessoryView.init(outputView: self, delegate: nil, color: superview?.backgroundColor)
            becomeFirstResponder()
        case .tags:
            keyboardType = .default
            becomeFirstResponder()
        case .description:
            keyboardType = .default
            becomeFirstResponder()
        }

    }
    
 
    func addDoneButtonToKeyboard() {
        let doneButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(DiaryTextView.finishDataEntry))
        let toolbar = UIToolbar()
        toolbar.frame.size.height = 45
        
        let space:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var items = [UIBarButtonItem]()
        items.append(space)
        items.append(doneButton)
        
        toolbar.items = items
        
        inputAccessoryView = toolbar
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
        resignFirstResponder()
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

extension DiaryTextView: APNumberPadDelegate {
    
}
