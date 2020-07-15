//
//  Transaction+iOS.swift
//  MyBudget
//
//  Created by Johannes on 15.07.20.
//  Copyright © 2020 Johannes Raufeisen. All rights reserved.
//

import Foundation
import Charts

// MARK: - Array of Transactions
// Extensions below are only available on iOS
extension Array where Element == Transaction {
    
    func monthlyExpenses() -> [BarChartMoneyEntry] {
        var expenses = [BarChartMoneyEntry]()
        
        guard let beginDate = Model.shared.firstDate() else {return expenses}
        guard let endDate = Model.shared.lastDate() else {return expenses}
        
        var currentDate = beginDate.firstDayOfCurrentMonth()
        while currentDate < endDate {
            guard let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) else {
                return expenses
            }

            // Calculate expenses in this month
            let expense = self.expenses(from: currentDate, to: nextDate)
            let timeString = currentDate.monthAsString() + " " + currentDate.yearAsString()

            let entry = BarChartMoneyEntry.init(label: timeString, money: expense)
            expenses.append(entry)
            currentDate = nextDate
        }
        
        return expenses
    }

    func monthlyIncomes() -> [BarChartMoneyEntry] {
        var incomes = [BarChartMoneyEntry]()
        
        guard let beginDate = Model.shared.firstDate() else {return incomes}
        guard let endDate = Model.shared.lastDate() else {return incomes}
        
        var currentDate = beginDate.firstDayOfCurrentMonth()
        while currentDate < endDate {
            guard let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) else {
                return incomes
            }

            // Calculate expenses in this month
            let expense = self.income(from: currentDate, to: nextDate)
            let timeString = currentDate.monthAsString() + " " + currentDate.yearAsString()

            let entry = BarChartMoneyEntry.init(label: timeString, money: expense)
            incomes.append(entry)
            currentDate = nextDate
        }
        
        return incomes
    }
    
}
