//
//  Transaction.swift
//  MyBudget
//
//  Created by Johannes on 24.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

// MARK: - TransactionType
enum TransactionType {
    case Income
    case Expense
    case Transfer
}

// MARK: - Transaction
protocol Transaction: DiaryProvider, CustomStringConvertible {
    var tags: [String] {get set}
    var value: Money { get set } //TODO: money
    var type: TransactionType { get }
    var transactionDescription: String {get set}
    var date: Date { get set }
    func ledgerString() -> String
    func ledgerTransaction() -> LedgerTransaction
}

// MARK: - IncomeTransaction
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
            (NSLocalizedString("Income", comment: "") + ": ", .money),
            ("\n" + NSLocalizedString("Account", comment: "banking account") + ": ", .account),
            ("\n" + NSLocalizedString("Name", comment: "of a transaction") + ": ", .description),
        ]
    }

    func ledgerTransaction() -> LedgerTransaction {
        var postings = [Posting]()
        postings.append(Posting.init(account: Account.bankingAccount(named: account), value: value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.incomeAccount(), value: -value.decimal.storage.decimalValue))

        return LedgerTransaction.init(name: transactionDescription, date: date, postings: postings, tags: tags)
    }
    
    func ledgerString() -> String {
        return """
        \(LedgerModel.dateString(date: date)) \(transactionDescription)
        \t \(Account.bankingAccount(named: account).name) \t \(Decimal.init(value.floatValue)) \(value.currencyCode)
        \t Income
        """
    }
    
}

// MARK: - ExpenseTransaction
class ExpenseTransaction: Transaction {
    
    var date: Date = Date()
    var type: TransactionType = .Expense
    var value: Money = 0
    var account: String = ""
    var transactionDescription: String = ""
    var category: String = ""
    var tags = [String]()
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
            (NSLocalizedString("Expense", comment: "") + ": ", .money),
            ("\n" + NSLocalizedString("Account", comment: "Banking account") + ": ", .account),
            ("\n" + NSLocalizedString("Category", comment: "Budgt category") + ": ", .category),
            ("\n" + NSLocalizedString("Name", comment: "Name of a transaction") + ": ", .description),
        ]
    }
        
    func ledgerString() -> String {
        return "TODO"
    }
    
    func ledgerTransaction() -> LedgerTransaction {
        var postings = [Posting]()
        /*
         ; Tag1
         Assets:Banking:Savings      -3.33 EUR
         Assets:Budget:Groceries      -3.33 EUR
         Expenses:Groceries      3.33 EUR
         Equity:AntiBudget:Groceries      3.33 EUR
         */
        postings.append(Posting.init(account: Account.bankingAccount(named: account), value: -value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.budgetAccount(named: category), value: -value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.expensesAccount(for: category) , value: value.decimal.storage.decimalValue))
        postings.append(Posting.init(account: Account.antiBudgetAccount(for: category), value: value.decimal.storage.decimalValue))

        return LedgerTransaction.init(name: transactionDescription, date: date, postings: postings, tags: tags)
    }
  
}

// MARK: - TransferTransaction
class TransferTransaction: Transaction {
    
    var type: TransactionType = .Transfer
    var value: Money = 0
    var fromAccount: String = ""
    var toAccount: String = ""
    var transactionDescription: String = ""
    var tags = [String]()
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
            (NSLocalizedString("Amount", comment: "of Money in a transaction") + ": ", .money),
            ("\n" + NSLocalizedString("From", comment: "payment from a banking account") + ": ", .account),
            ("\n" + NSLocalizedString("To", comment: "payment in a banking account") + ": ", .account),
            ("\n" + NSLocalizedString("Name", comment: "of a transaction") + ": ", .description),
        ]
    }
    
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
        return LedgerTransaction.init(name: transactionDescription, date: date, postings: postings, tags: tags)
    }

}

// MARK: - Array of Transactions
extension Array where Element == Transaction {
    
    func expenses(from: Date, to: Date) -> Money {
        var sum = Money.init(0)
        for tx in self {
            if let tx = tx as? ExpenseTransaction {
                if tx.date >= from && tx.date <= to {
                    sum = sum.adding(tx.value)
                }
            }
        }
        return sum
    }
    
    func income(from: Date, to: Date) -> Money {
        var sum = Money.init(0)
        for tx in self {
            if let tx = tx as? IncomeTransaction {
                if tx.date >= from && tx.date <= to {
                    sum = sum.adding(tx.value)
                }
            }
        }
        return sum
    }
        
    func spendingsPerCategory() -> [String: Money] {
        var spendingsPerCategory = [String: Money]()
        
        for tx in self {
            if let tx = tx as? ExpenseTransaction {
                let category = tx.category
                if let preValue = spendingsPerCategory[category] {
                    spendingsPerCategory[category] = preValue + tx.value
                } else {
                    spendingsPerCategory[category] = tx.value
                }
            }
        }

        return spendingsPerCategory
    }
    
}
