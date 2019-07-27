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

 
    @IBOutlet weak var diaryTextView: DiaryTextView!
    private var transaction: Transaction = IncomeTransaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackground()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        diaryTextView.configure(diaryProvider: transaction)
        diaryTextView.diaryDelegate = self
    }

    private func addfloatingButton() {
        let floaty = Floaty()
        floaty.buttonColor = .white
        floaty.plusColor = UIColor.colorForTransaction(type: transaction.type) // Assign tint color to imageview
        floaty.itemSize = 50
        floaty.handleFirstItemDirectly = true
        floaty.buttonImage = UIImage.init(named: "verify-sign")?.withRenderingMode(.alwaysTemplate)
        
        let item = FloatyItem()
        item.tintColor = .white
        item.buttonColor = .blue
        item.size = floaty.itemSize
        item.handler = { (item) in
            print("I will now add transaction \(self.transaction)")
            Model.shared.addTransaction(transaction: self.transaction)
            self.navigationController?.popViewController(animated: true)
        }
        floaty.addItem(item: item)

        view.addSubview(floaty)
    }
   
    
    private func updateBackground() {
        self.view.backgroundColor = UIColor.colorForTransaction(type: transaction.type)
      
    }
    
    

}

extension EnterNumberViewController: DiaryDelegate {
    func didFinishDiaryEntry() {
        addfloatingButton()
    }
    
    
    func didEnterDiaryPair(index: Int, value: Any) {
        print("I received \(value) at \(index)")
        switch transaction.type {
        case .Income:
            processIncomeEntry(index: index, value: value)
        case .Expense:
            processExpenseEntry(index: index, value: value)
        case .Transfer:
            processTransferEntry(index: index, value: value)
        }
    }
    
    private func processIncomeEntry(index: Int, value: Any) {
        guard let transaction = self.transaction as? IncomeTransaction else {
            fatalError("Wrong transaction type was chosen. Cannot process information")
            return
        }
        let entryType = transaction.diaryEntry()[index].entryType
        
        switch entryType {
        case .money:
            guard let value = value as? Int else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.value = NSNumber.init(value: Float(value) / 100)

        case .date:
            print("Date not implemented yet")
        case .account:
            guard let name = value as? String else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.account = name
        case .category:
            // Category not relevant for income
            break
        case .tags:
            print("Tags not implemented yet")
        case .description:
            guard let desc = value as? String else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.transactionDescription = desc
        }
        self.transaction = transaction
    }
    
    
    private func processTransferEntry(index: Int, value: Any) {
        guard let transaction = self.transaction as? TransferTransaction else {
            fatalError("Wrong transaction type was chosen. Cannot process information")
            return
        }
        let entryType = transaction.diaryEntry()[index].entryType
        switch entryType {
        case .money:
            guard let value = value as? Int else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.value = NSNumber.init(value: Float(value) / 100)

        case .date:
            print("Date not implemented yet")
        case .account:
            guard let name = value as? String else {
                print("Unexpected type. Cannot process information")
                return
            }
            
            //Check if first account or second account
            var isFromAccount = false
            for i in 0...transaction.diaryEntry().count {
                let entry = transaction.diaryEntry()[i]
                if entry.entryType == .account {
                    isFromAccount = (i == index)
                    break
                }
            }
            
            if isFromAccount {
                transaction.fromAccount = name
            } else {
                transaction.toAccount = name
            }
        case .category:
            //not relevant for transfer
            break
        case .tags:
            print("Tags not implemented yet")
        case .description:
            guard let desc = value as? String else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.transactionDescription = desc
        }
        self.transaction = transaction
    }
    
    private func processExpenseEntry(index: Int, value: Any) {
        guard let transaction = self.transaction as? ExpenseTransaction else {
            fatalError("Wrong transaction type was chosen. Cannot process information")
        }
        let entryType = transaction.diaryEntry()[index].entryType
        
        switch entryType {
        case .money:
            guard let value = value as? Int else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.value = NSNumber.init(value: Float(value) / 100)

        case .date:
            print("Date not implemented yet")
        case .account:
            guard let name = value as? String else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.account = name
        case .category:
            guard let category = value as? String else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.category = category
        case .tags:
            print("Tags not implemented yet")
        case .description:
            guard let desc = value as? String else {
                print("Unexpected type. Cannot process information")
                return
            }
            transaction.transactionDescription = desc
        }
        self.transaction = transaction
    }
    
}
