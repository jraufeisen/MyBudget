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
            processExpenseEntry(index: index, value: value)
        }
    }
    
    private func processIncomeEntry(index: Int, value: Any) {
        //let entryType = transaction.diaryEntry()[index]
    }
    
    private func processTransferEntry(index: Int, value: Any) {
        //let entryType = transaction.diaryEntry()[index]

    }
    
    private func processExpenseEntry(index: Int, value: Any) {
        //let entryType = transaction.diaryEntry()[index]
    }
    
}
