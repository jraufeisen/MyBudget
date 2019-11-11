//
//  Date+Utilities.swift
//  LedgerClient
//
//  Created by Johannes on 24.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

extension Date {
    
    /*
    *   Returns the first day of the current month
    */
    func firstDayOfCurrentMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func decrementByOneMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    
    func monthAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: self)
        return nameOfMonth
    }
    
    func yearAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let nameOfMonth = dateFormatter.string(from: self)
        return nameOfMonth

    }
}
