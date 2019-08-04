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
    let remainingMoney: Money
    let percentLeft: Double // Between 0 and 100
    let detailString: String
}

struct AccountViewable {
    let name: String
    let remainingMoney: Money
    let spentThisMonth: Money
    let earnedThisMonth: Money
}

/// Income statement across all accounts
struct IncomeStatementViewable {
    let spentThisMonth: Money
    let earnedThisMonth: Money
}

class Model: NSObject {

    static let shared = Model()
    private override init() {
        
    }
    
    /// Income statement for whole month and all accounts
    func getIncomeStatementViewable() -> IncomeStatementViewable {
        let bankingAccount = Account.init(name: "Assets:Banking")

        let spentThisMonth = LedgerModel.shared().expenseSinceDate(acc: bankingAccount, date: Date().firstDayOfCurrentMonth())
        let earnedThisMonth = LedgerModel.shared().incomeSinceDate(acc: bankingAccount, date: Date().firstDayOfCurrentMonth())
        
        let viewable = IncomeStatementViewable.init(spentThisMonth: Money((spentThisMonth as NSNumber).floatValue), earnedThisMonth: Money((earnedThisMonth as NSNumber).floatValue))

        return viewable
    }
    
    /// Sorted by name
    func getAllAccountViewables() -> [AccountViewable] {
        var accountViewables = [AccountViewable]()
        let names = getAllAccountNames()
        
        for name in names {
            let bankingAccount = Account.init(name: "Assets:Banking:\(name)")
            let remainingMoney = LedgerModel.shared().balanceForAccount(acc: bankingAccount)
            let spentThisMonth = LedgerModel.shared().expenseSinceDate(acc: bankingAccount, date: Date().firstDayOfCurrentMonth())
            let earnedThisMonth = LedgerModel.shared().incomeSinceDate(acc: bankingAccount, date: Date().firstDayOfCurrentMonth())
            let viewable = AccountViewable.init(name: name, remainingMoney: Money((remainingMoney as NSNumber).floatValue), spentThisMonth: Money((spentThisMonth as NSNumber).floatValue), earnedThisMonth: Money((earnedThisMonth as NSNumber).floatValue))
            accountViewables.append(viewable)
        }
        
        return accountViewables.sorted(by: { (v1, v2) -> Bool in
            v1.name < v2.name
        })
    }
    
    /// Only returns banking accounts. only last component
    func getAllAccountNames() -> [String] {
        var names = [String]()
        for acc in LedgerModel.shared().accounts {
            if acc.name.contains("Assets:Banking:"), let humanName = acc.name.components(separatedBy: ":").last {
                if !names.contains(humanName) {
                    names.append(humanName)
                }
            }
        }
        return names
    }
    
    /// Sorted by name
    func getAllBudgetCategories() -> [BudgetCategoryViewable] {
        var categoryViewables = [BudgetCategoryViewable]()
        let dummyCategories = LedgerModel.shared().categories()
        guard dummyCategories.count > 0 else {return categoryViewables}
        
        for i in 0...dummyCategories.count-1 {
            let category = dummyCategories[i]
            let categoryAccount = Account.init(name: "Expenses:\(category)")
            let remainingMoney = LedgerModel.shared().budgetInCategory(category: category)
            let spentThisMonth = LedgerModel.shared().balanceSinceDate(acc: categoryAccount, date: Date().firstDayOfCurrentMonth())
            let spentVsBudgeted = remainingMoney / (remainingMoney+spentThisMonth)
            var fillPercent = (spentVsBudgeted as NSNumber).doubleValue
            if fillPercent.isNaN || fillPercent.isInfinite {
                fillPercent = 0
            }
            let detailText = "You have spent \(100-Int(fillPercent*100)) % of this month's budget"
            
            let viewable = BudgetCategoryViewable.init(name: dummyCategories[i], remainingMoney: Money.init((remainingMoney as NSNumber).floatValue), percentLeft: fillPercent, detailString: detailText)
            categoryViewables.append(viewable)
        }
        
        return categoryViewables.sorted(by: { (bv1, bv2) -> Bool in
            bv1.name < bv2.name
        })
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
        _ = LedgerModel.shared().postIncome(acc: Account.init(name: "Assets:Banking:\(transaction.account)"), value: "\(transaction.value.amount)", description: transaction.transactionDescription)
    }
    private func addTransaction(transaction: ExpenseTransaction) {
        _ = LedgerModel.shared().postExpense(acc: "Assets:Banking:\(transaction.account)", value: "\(transaction.value.amount)", category: transaction.category, description: transaction.transactionDescription)
    }
    private func addTransaction(transaction: TransferTransaction) {
        let from = Account.init(name: "Assets:Banking:\(transaction.fromAccount)")
        let to = Account.init(name: "Assets:Banking:\(transaction.toAccount)")
        _ = LedgerModel.shared().postTransfer(from: from, to: to, value: "\(transaction.value.amount)", description: transaction.transactionDescription)
    }
    
    /// Sorted by date
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
                    relevantTx.value = Money(dec.floatValue)
                    relevantTx.date = tx.date
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
    
    func unbudgetedMoney() -> Money {
        
        let budgetAccount = Account.init(name: "Assets:Budget")
        let moneyAccount = Account.init(name:"Assets:Banking")
        let budgeted = LedgerModel.shared().balanceForAccount(acc: budgetAccount)
        let owned = LedgerModel.shared().balanceForAccount(acc: moneyAccount)
        
        let dec = NSDecimalNumber.init(decimal: owned - budgeted)

        return Money.init(dec.floatValue)
    }
    
    func setBudget(category: String, newValue: Money) {
        let budgetAccount = Account.init(name: "Assets:Budget:\(category)")
        let currentValue = LedgerModel.shared().balanceForAccount(acc: budgetAccount)
        
        let currentNumber = NSNumber.init(value: (currentValue as NSDecimalNumber).floatValue)
        let updateValue = NSNumber.init(value:  newValue.floatValue - currentNumber.doubleValue)
        _ = LedgerModel.shared().addBudget(category: category, value: "\(updateValue)")
    }
    
}
