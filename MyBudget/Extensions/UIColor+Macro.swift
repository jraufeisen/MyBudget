//
//  UIColor+Macro.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var incomeColor = UIColor.init(red: 0/255, green: 175/255, blue: 68/255, alpha: 1.0)
    static var expenseColor = UIColor.init(red: 204/255, green: 0/255, blue: 0/255, alpha: 1.0)
    static var transferColor = UIColor.init(red: 250/255, green: 193/255, blue: 0/255, alpha: 1.0)

    static var blueActionColor = UIColor(red: 73/255.0, green: 151/255.0, blue: 241/255.0, alpha: 1)

    
    static func colorForTransaction(type: TransactionType) -> UIColor {
        if type == .Income {
            return UIColor.incomeColor
        } else if type == .Expense {
            return UIColor.expenseColor
        } else if type == .Transfer {
            return UIColor.transferColor
        }
        return UIColor.purple
    }
}

