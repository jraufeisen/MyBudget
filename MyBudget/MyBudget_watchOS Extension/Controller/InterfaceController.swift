//
//  InterfaceController.swift
//  LedgerWatch Extension
//
//  Created by Johannes on 11.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import WatchKit
import Foundation


///The two possible cases for an entry: Income and Expense
public enum NumberContext {
    case Expense
    case Income
    case Transfer
}


///This struct will be used to pass relevant context information to upfollowing interface controllers
public struct EntryContext {
    var type: NumberContext?
    var money: String?
    var account1: String?
    var account2: String?
    var budgetCategory: String?
    var description: String?
    
    init(type: NumberContext? = nil, money: String? = nil, account1: String? = nil, account2: String? = nil, budgetCategory: String? = nil, description: String? = nil) {
        self.type = type
        self.money = money
        self.account1 = account1
        self.account2 = account2
        self.budgetCategory = budgetCategory
        self.description = description
    }
}



class InterfaceController: WKInterfaceController {

    @IBOutlet var categoriesTableView: WKInterfaceTable!
    
    @IBOutlet var incomeButton: WKInterfaceButton!
    @IBOutlet var transferButton: WKInterfaceButton!
    @IBOutlet var expenseButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        //Start communication session
        WatchSessionManager.sharedManager.startSession()
        
        incomeButton.setBackgroundColor(UIColor.incomeColor)
        transferButton.setBackgroundColor(UIColor.transferColor)
        expenseButton.setBackgroundColor(UIColor.expenseColor)
    }
    

    @IBAction func createNewIncome() {
        pushController(withName: "enterNumber", context: EntryContext.init(type: .Income))
    }
    
    
    @IBAction func createNewTransfer() {
        pushController(withName: "enterNumber", context: EntryContext.init(type: .Transfer))
    }
    
    @IBAction func createNewExpense() {
        pushController(withName: "enterNumber", context: EntryContext.init(type: .Expense))
    }
}

