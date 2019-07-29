//
//  Transaction.swift
//  MyBudget
//
//  Created by Johannes on 24.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit



protocol Transaction: DiaryProvider, CustomStringConvertible {
    var tags: [String] {get set}
    var value: Money { get set } //TODO: money
    var type: TransactionType { get }
    var transactionDescription: String {get set}
    func ledgerString() -> String
}

class IncomeTransaction: Transaction {
   
    
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


    
    func ledgerString() -> String {
        return "TODO"
    }
}

class ExpenseTransaction: Transaction {
    
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
    
   

  
}

class TransferTransaction: Transaction {
    
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
        return "TODO"
    }
}
