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
    var value: NSNumber { get set } //TODO: money
    var type: TransactionType { get }
    var transactionDescription: String {get set}
    func ledgerString() -> String
}

class IncomeTransaction: Transaction {
   
    
    var type: TransactionType = .Income


    var value: NSNumber = 0
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
            (", I have added ", .money),
            (" to my account ", .account),
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
            (".\nAdditional notes: ", .description),
        ]
    }
    
    var type: TransactionType = .Expense
    
    var value: NSNumber = 0
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
            (", I transfered ", .money),
            (" from my ", .account),
            (" account to my ", .account),
            (" account.", .description),
        ]
    }
    
 
    
    var type: TransactionType = .Transfer
    
    var value: NSNumber = 0
    var fromAccount: String = ""
    var toAccount: String = ""
    var transactionDescription: String = ""
    var tags = [String]()

  
    
    func ledgerString() -> String {
        return "TODO"
    }
}
