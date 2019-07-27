//
//  Transaction.swift
//  LedgerClient
//
//  Created by Johannes on 23.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

/*
 One transaction is the parsed content of e.g.
 
 2017/10/08 Tanken
    Assets:Banking:Kreditkarte -48.27 EUR
    (Assets:Budget:Sprit)      -48.27 EUR
    Expenses:Sprit              48.27 EUR
    Equity:AntiBudget:Sprit


 Name
 Date
 Postings to different accounts
 
 */

class LedgerTransaction: NSObject {

    let name: String
    let date: Date
    let postings: [ (Account,Decimal) ]
    
    override var description: String {
        return "Transaction \(name) on \(date) with postings \(postings)"
    }
    
    
    init(name: String, date: Date, postings: [ (Account, Decimal) ]) {
        self.name = name
        self.date = date
        self.postings = postings
        super.init()
    }
    
    
    /*
     Initializes a single trnsaction described in ledger-syntax
    */
    init?(ledgerString: String) {
        let cleanedLedger = ledgerString.trimmingCharacters(in: .whitespaces)
        
        //Parse date from the 1st line
        guard let date = Parser.parseDateFromLine(line: cleanedLedger) else { return nil }
        self.date = date
       
        //Parse name from the 1st line
        guard let name = Parser.parseNameFromLine(line: cleanedLedger) else {return nil}
        self.name = name
        
        var postings = [(Account, Decimal)]()
        var equityAccount: Account? = nil
        var equitySum: Decimal = 0
        for lineSubString in cleanedLedger.split(separator: "\n").dropFirst() {
            let line = String(lineSubString)
            if let (acc, val) = Parser.parsePostingFromLine(line: line) {
                if val == Decimal.nan {
                    //Set equity account
                    guard equityAccount == nil else {return nil}
                    equityAccount = acc
                } else {
                    //Append dictionary
                    postings.append((acc, val))
                    equitySum -= val
                }
                
            }
        }
        
        //After having parsed all postings, calulate the sum for the equity posting (there must not be more than two postings with empty value)
        if let eqAcc = equityAccount {
            postings.append( (eqAcc, equitySum) )
        } else if equitySum != 0 {
            print("Warning: There is an unbalanced transaction \(equitySum). Parse it anyway... (since this my be caused by intentionally unbalanced virtual transactions)")
        }
        
        self.postings = postings
        
        super.init()
    }
    
    //MARK: Business Logic
    func valueForAccount(acc: Account) -> Decimal {

        var sum: Decimal = 0
        for (key, val) in postings {
            //Important: Use .contains here, cause asking for "Assets:Budget" should also consider "Assets:Budget:Clothes"
            if key.name.contains(acc.name) { sum += val}
        }
        return sum
    }
    
    
    func isIncome() -> Bool {
        return !isExpense()
    }
    
    func isExpense() -> Bool {
        for (account, _) in postings {
            if account.name.contains("Expense") {return true}
        }
        
        return false
    }
    
    /**
     Most transactions contain more than one posting due to virtual postings for example.
     The end-user is only interested in the "real" (i.e. non virtual transaction that occurred)
     */
    func effectiveValue() -> Decimal {
        var value: Decimal = 0
        for (account, _) in postings {
            if account.name.contains("Banking") {
                value += valueForAccount(acc: account)
            }
        }
        
        return value
    }
    
}
