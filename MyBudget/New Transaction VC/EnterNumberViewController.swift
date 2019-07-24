//
//  EnterNumberViewController.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class EnterNumberViewController: UIViewController {

    /// Use this method to configure the View controller appropriately.
    internal static func instantiate(with type: TransactionType) -> EnterNumberViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterAmountVC") as! EnterNumberViewController
        switch type {
        case .Income:
            vc.transaction = IncomeTransaction()
        case .Expense:
            vc.transaction = ExpenseTransaction()
        case .Transfer:
            vc.transaction = TransferTransaction()
        }
        return vc
    }

 
    @IBOutlet weak var diaryTextField: UITextView!
    private var transaction: Transaction = IncomeTransaction()
    private var diaryEntry: DiaryEntry = IncomeTransaction().diaryEntry()
    private var currentDiaryIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackground()
        diaryEntry = transaction.diaryEntry()
        nextDiaryEntry()
    }

    func updateBackground() {
        if transaction.type == .Income {
            self.view.backgroundColor = UIColor.incomeColor
        } else if transaction.type == .Expense {
            self.view.backgroundColor = UIColor.expenseColor
        } else if transaction.type == .Transfer {
            self.view.backgroundColor = UIColor.transferColor
        }
    }
    
    /// - Returns: True, if there is another entry type that can be entered. False otherwise.
    private func nextDiaryEntryIsAvailable() -> Bool {
        return currentDiaryIndex < diaryEntry.count-1
    }
    
    /// Displays the next data entry for the current diary.
    private func nextDiaryEntry() {
        guard nextDiaryEntryIsAvailable() else {
            diaryTextField.resignFirstResponder()
            return
        }
        currentDiaryIndex += 1
        let currentEntry = diaryEntry[currentDiaryIndex]
        // Display new text
        // Special case: If we ask for the date in the beginning, we set the default value to today and skip the initial data entry
        if currentDiaryIndex == 0 && currentEntry.entryType == .date {
            diaryTextField.text = "Today"
            nextDiaryEntry()
            return
        }
        
        diaryTextField.text += currentEntry.text

        // Ask for new input depending on the entry type
        diaryTextField.textContentType = .telephoneNumber
        diaryTextField.becomeFirstResponder()
    }
    

}

extension EnterNumberViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            return textViewShouldReturn()
        }
        
        return true
    }
    
    private func textViewShouldReturn() -> Bool {
        nextDiaryEntry()
        return false
    }
    
}
