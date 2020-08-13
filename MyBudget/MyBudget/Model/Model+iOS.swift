//
//  File.swift
//  MyBudget
//
//  Created by Johannes on 07.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation
import Swift_Ledger

// Extension below is only available on iOS (for various reasons, some might be ported to watchOS)
extension Model {
    
    func allowedToAddTransaction() -> Bool {
        return ServerReceiptValidator().isFullVersion() || numberOfRemainingTransactions() > 0 || numberOfRemainingTransactionsToday() > 0
    }
    
    /// Based on the reduced limit of 0 per day
    func numberOfRemainingTransactionsToday() -> Int {
        return 0
    }
    
    /// Based on the blobal limit of 100 tx in the free version
    func numberOfRemainingTransactions() -> Int {
        let txCount = LedgerModel.shared().transactions.count
        return max(100 - txCount,0)
    }
    
    /// Save initial budget distribution to ledger.
    /// This method returns silently without any effect, if there are already saved transactions or accounts in the ledger file.
    /// - Parameters:
    ///   - accounts: The user's accounts added during onboarding process
    ///   - categories: The user's budget categories added during onboarding process
    func createInitialBudget(accounts: [OnboardingAccountViewable], categories: [CategorySelectable]) {
        
        // Dont overwrite anything that already exists!
        guard ledgerFileIsEssentialyEmpty() else {
            return
        }
        
        for account in accounts {
            addBankingAccount(name: account.name , balance: account.money)
        }
        
        for category in categories {
            addBudgetCategory(name: category.name, balance: category.assignedMoney)
        }
    }
    
}
