//
//  Transaction.swift
//  MyBudget
//
//  Created by Johannes on 24.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit


enum EntryType {
    case date
    case money
    case account
    case category
    case tags
    case description
}
typealias DiaryEntry = [(text: String, entryType: EntryType)]

protocol Transaction {
    var tags: [String] {get set}
    var value: NSNumber { get set } //TOdo: money
    var type: TransactionType { get }
    var description: String {get set}
    func diaryEntry() -> DiaryEntry
    func ledgerString() -> String
}

class IncomeTransaction: Transaction {
   
    
    var type: TransactionType = .Income


    var value: NSNumber = 0
    var account: String = ""
    var description: String = ""
    var tags = [String]()

    
    func diaryEntry() -> DiaryEntry {
        return [
            ("", .date),
            (", I have added", .money),
            ("to my account", .account),
            (".\n", .tags)
        ]
    }
    
    func ledgerString() -> String {
        return "TODO"
    }
}

class ExpenseTransaction: Transaction {
    func diaryEntry() -> DiaryEntry {
        return [
            ("", .date),
            (", I spent", .money),
            ("from my", .account),
            ("account on", .category),
            ("(", .description),
            (")\n", .tags),
        ]
    }
    
    var type: TransactionType = .Expense
    
    var value: NSNumber = 0
    var account: String = ""
    var description: String = ""
    var category: String = ""
    var tags = [String]()
    
    func ledgerString() -> String {
        return "TODO"
    }
    
   

  
}

class TransferTransaction: Transaction {
    func diaryEntry() -> DiaryEntry {
        return [
            ("", .date),
            (", I transfered", .money),
            ("from my", .account),
            ("account to my", .account),
            ("account.", .description),
            ("\n", .tags),
        ]
    }
    
 
    
    var type: TransactionType = .Transfer
    
    var value: NSNumber = 0
    var fromAccount: String = ""
    var toAccount: String = ""
    var description: String = ""
    var tags = [String]()

  
    
    func ledgerString() -> String {
        return "TODO"
    }
}
