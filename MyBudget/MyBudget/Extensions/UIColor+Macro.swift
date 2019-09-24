//
//  UIColor+Macro.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var incomeColor = UIColor.systemGreen
    static var expenseColor = UIColor.systemRed
    static var transferColor = UIColor.systemYellow

    static var blueActionColor = UIColor(red: 73/255.0, green: 151/255.0, blue: 241/255.0, alpha: 1)

    
    static func colorForTransaction(type: TransactionType) -> UIColor {
        if type == .Income {
            return UIColor.incomeColor
        } else if type == .Expense {
            return UIColor.expenseColor
        } else if type == .Transfer {
            return UIColor.transferColor
        }
        return UIColor.systemPurple
    }
}

