//
//  UIColor+Macro.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

extension UIColor {
    
    #if os(watchOS)
    // WatchOS does not provide system colors (no dark mode), so differentiate here
    static var incomeColor = UIColor(red: 0.15, green: 0.78, blue: 0.38, alpha: 1)  // RGB values of systemGreen in bright mode
    static var expenseColor = UIColor(red: 1, green: 0.22, blue: 0.22, alpha: 1)    // RGB values of systemRed in bright mode
    static var transferColor = UIColor(red: 1, green: 0.79, blue: 0.23, alpha: 1)   // RGB values of systemYellow in bright mode
    #else
    static var incomeColor = UIColor.systemGreen
    static var expenseColor = UIColor.systemRed
    static var transferColor = UIColor.systemYellow
    #endif

    static var blueActionColor = UIColor(red: 73/255.0, green: 151/255.0, blue: 241/255.0, alpha: 1)

    static func colorForTransaction(type: TransactionType) -> UIColor {
        if type == .Income {
            return UIColor.incomeColor
        } else if type == .Expense {
            return UIColor.expenseColor
        } else if type == .Transfer {
            return UIColor.transferColor
        }
        #if os(watchOS)
        return UIColor.purple
        #else
        return UIColor.systemPurple
        #endif
    }
    
}

extension UIColor {
    
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor? {
        let f = min(max(0, fraction), 1)

        guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return nil }

        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}

