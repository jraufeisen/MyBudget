//
//  Transaction.swift
//  MyBudget
//
//  Created by Johannes on 24.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

enum TransactionType {
    case Income
    case Expense
    case Transfer
}

protocol Transaction: DiaryProvider, CustomStringConvertible {
    var tags: [String] {get set}
    var value: Money { get set } //TODO: money
    var type: TransactionType { get }
    var transactionDescription: String {get set}
    var date: Date { get set }
    func ledgerString() -> String
    func ledgerTransaction() -> LedgerTransaction
}

class IncomeTransaction: Transaction {
    var date: Date = Date()
    
   
    
    var type: TransactionType = .Income

    
    var value: Money = 0
    var account: String = ""
    var transactionDescription: String = ""
    var tags = [String]()

    
    var description: String {
        get {
            return """
            Income
            - Value: \(value)
            - From Account: \(account)
            - Tags: \(tags)
            - Description: \(transactionDescription)
            """
        }
    }

    func diaryEntry() -> DiaryEntry {
        return [
            ("", .date),
            (", I added ", .money),
            (" to my account ", .account),
            (".\nName: ", .description),
        ]
    }

    func ledgerTransaction() -> LedgerTransaction {
        var postings = [Posting]()
        postings.append(Posting.init(account: Account.bankingAccount(named: account), value: value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.incomeAccount(), value: -value.decimal.storage.decimalValue))

        return LedgerTransaction.init(name: transactionDescription, date: date, postings: postings)
    }
    
    func ledgerString() -> String {
        return """
        \(LedgerModel.dateString(date: date)) \(transactionDescription)
        \t \(Account.bankingAccount(named: account).name) \t \(Decimal.init(value.floatValue)) \(value.currencyCode)
        \t Income
        """
    }
}

class ExpenseTransaction: Transaction {
    var date: Date = Date()

    var description: String {
        get {
            return """
            Expense
            - Value: \(value)
            - From Account: \(account)
            - In Category: \(category)
            - Description: \(transactionDescription)
            - Tags: \(tags)
            """
        }
    }
    
    
    func diaryEntry() -> DiaryEntry {
        return [
            ("", .date),
            (", I spent ", .money),
            (" from my ", .account),
            (" account on ", .category),
            (".\nName: ", .description),
        ]
    }
    
    var type: TransactionType = .Expense
    
    var value: Money = 0
    var account: String = ""
    var transactionDescription: String = ""
    var category: String = ""
    var tags = [String]()
    
    func ledgerString() -> String {
        return "TODO"
    }
    func ledgerTransaction() -> LedgerTransaction {
        var postings = [Posting]()
        /*
         Assets:Banking:Savings      -3.33 EUR
         Assets:Budget:Groceries      -3.33 EUR
         Expenses:Groceries      3.33 EUR
         Equity:AntiBudget:Groceries      3.33 EUR
         */
        postings.append(Posting.init(account: Account.bankingAccount(named: account), value: -value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.budgetAccount(named: category), value: -value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.expensesAccount(for: category) , value: value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.antiBudgetAccount(for: category), value: value.decimal.storage.decimalValue))

        return LedgerTransaction.init(name: transactionDescription, date: date, postings: postings)
    }

   

  
}

class TransferTransaction: Transaction {
    var date: Date = Date()

    var description: String {
        get {
            return """
            Transfer
            - Value: \(value)
            - From Account: \(fromAccount)
            - To Account: \(toAccount)
            - Description: \(transactionDescription)
            - Tags: \(tags)
            """
        }
    }
    
    func diaryEntry() -> DiaryEntry {
        return [
            ("", .date),
            (", I transferred ", .money),
            (" from my ", .account),
            (" account to my ", .account),
            (" account.\nName: ", .description),
        ]
    }
    
 
    
    var type: TransactionType = .Transfer
    
    var value: Money = 0
    var fromAccount: String = ""
    var toAccount: String = ""
    var transactionDescription: String = ""
    var tags = [String]()

  
    func ledgerString() -> String {
        return """
        \(LedgerModel.dateString(date: date)) \(transactionDescription)
        \t \(Account.bankingAccount(named: fromAccount).name) \t \(Decimal.init(-value.floatValue)) \(value.currencyCode)
        \t \(Account.bankingAccount(named: toAccount).name) \t \(Decimal.init(value.floatValue)) \(value.currencyCode)
        """
    }
    
    func ledgerTransaction() -> LedgerTransaction {
        var postings = [Posting]()
        
        postings.append(Posting.init(account: Account.bankingAccount(named: fromAccount), value: -value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.bankingAccount(named: toAccount), value: value.decimal.storage.decimalValue))

        return LedgerTransaction.init(name: transactionDescription, date: date, postings: postings)
    }

}
