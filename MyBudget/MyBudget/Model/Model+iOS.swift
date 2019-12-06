//
//  File.swift
//  MyBudget
//
//  Created by Johannes on 07.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation
import Swift_Ledger

extension Model {
    
    func allowedToAddTransaction() -> Bool {
        return ServerReceiptValidator().isSubscribed() || numberOfRemainingTransactions() > 0 || numberOfRemainingTransactionsToday() > 0
    }
    
    /// Based on the reduced limit of 1 per day
    func numberOfRemainingTransactionsToday() -> Int {
        let txToday = LedgerModel.shared().transactions.filter { (tx) -> Bool in
            LedgerModel.dateString(date: tx.date) == LedgerModel.dateString(date: Date())
        }
        return max(1-txToday.count, 0)
    }
    
    /// Based on the blobal limit of 100 tx in the free version
    func numberOfRemainingTransactions() -> Int {
        let txCount = LedgerModel.shared().transactions.count
        return max(100 - txCount,0)
    }
    
}
