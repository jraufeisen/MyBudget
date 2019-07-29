//
//  Model.swift
//  MyBudget
//
//  Created by Johannes on 23.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit


struct BudgetCategoryViewable {
    let name: String
    let remainingMoney: NSNumber //Todo: Money
    let percentLeft: NSNumber // Between 0 and 100
    let detailString: String
}

class Model: NSObject {

    static let shared = Model()
    private override init() {
        
    }
    
    func getAllAccountNames() -> [String] {
        var names = [String]()
        for acc in LedgerModel.shared().accounts {
            names.append(acc.name)
        }
        return names
    }
    
    func getAllBudgetCategories() -> [BudgetCategoryViewable] {
        var categoryViewables = [BudgetCategoryViewable]()
        
        let dummyCategories = LedgerModel.shared().categories()
        for i in 0...dummyCategories.count-1 {
            let category = dummyCategories[i]
            let remainingMoney = LedgerModel.shared().budgetInCategory(category: category) as NSNumber
            
            let viewable = BudgetCategoryViewable.init(name: dummyCategories[i], remainingMoney: remainingMoney, percentLeft: NSNumber(value: i*20), detailString: "")
            categoryViewables.append(viewable)
        }
        
        return categoryViewables
    }
    
    func addTransaction(transaction: Transaction) {
        switch transaction.type {
        case .Income:
            addTransaction(transaction: transaction as! IncomeTransaction)
        case .Expense:
            addTransaction(transaction: transaction as! ExpenseTransaction)
        case .Transfer:
            addTransaction(transaction: transaction as! TransferTransaction)
        }
        
    }
    
    private func addTransaction(transaction: IncomeTransaction) {
        _ = LedgerModel.shared().postIncome(acc: Account.init(name: transaction.account), value: "\(transaction.value)", description: transaction.transactionDescription)
    }
    private func addTransaction(transaction: ExpenseTransaction) {
        _ = LedgerModel.shared().postExpense(acc: transaction.account, value: "\(transaction.value)", category: transaction.category, description: transaction.transactionDescription)
    }
    private func addTransaction(transaction: TransferTransaction) {
        let from = Account.init(name: transaction.fromAccount)
        let to = Account.init(name: transaction.toAccount)
        _ = LedgerModel.shared().postTransfer(from: from, to: to, value: "\(transaction.value)", description: transaction.transactionDescription)
    }
    
    
    func transactions(for category: String) -> [Transaction] {
        var transactions = [Transaction]()
        
        for tx in LedgerModel.shared().transactions {
        
            let relevantTx = ExpenseTransaction.init()
            for post in tx.postings {
                // do not include budgeting transactions, only real expenses
                if post.0.name.contains(category) && tx.isExpense() {
                    
                    relevantTx.category = category
                    relevantTx.transactionDescription = tx.name
                    let dec = NSDecimalNumber.init(decimal: post.1)
                    relevantTx.value = NSNumber(value: dec.floatValue )
                }
                
                if post.0.name.contains("Banking:") {
                    if let bankingAccount = post.0.name.components(separatedBy: ":").last {
                        relevantTx.account = bankingAccount
                    }
                }
            }
            
            if !relevantTx.category.isEmpty {
                transactions.append(relevantTx)
            }
            
        }
        
        return transactions
    }
    
    func unbudgetedMoney() -> NSNumber {
        
        let budgetAccount = Account.init(name: "Assets:Budget")
        let moneyAccount = Account.init(name:"Assets:Banking")
        let budgeted = LedgerModel.shared().balanceForAccount(acc: budgetAccount)
        let owned = LedgerModel.shared().balanceForAccount(acc: moneyAccount)
        
        let dec = NSDecimalNumber.init(decimal: owned - budgeted)

        return NSNumber(value: dec.floatValue )
    }
    
    func setBudget(category: String, newValue: NSNumber) {
        let budgetAccount = Account.init(name: "Assets:Budget:\(category)")
        let currentValue = LedgerModel.shared().balanceForAccount(acc: budgetAccount)
        
        let currentNumber = NSNumber.init(value: (currentValue as NSDecimalNumber).floatValue)
        let updateValue = NSNumber.init(value:  newValue.floatValue - currentNumber.floatValue)
        
        _ = LedgerModel.shared().addBudget(category: category, value: "\(updateValue)")
    }
    
}
