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
    
    

}

