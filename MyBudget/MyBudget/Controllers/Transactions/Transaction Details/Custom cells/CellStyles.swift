//
//  EditTransactionDetailsBaseCell.swift
//  MyBudget
//
//  Created by Johannes on 27.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

enum EditTransactionDetailsCellStyles {
    case expense
    case income
    case transfer
    case gray
    
    func primaryColor() -> UIColor {
        switch self {
        case .expense:
            return UIColor.expenseColor
        case .income:
            return UIColor.incomeColor
        case .transfer:
            return UIColor.transferColor
        case .gray:
            return UIColor.systemGray
        }
    }
    
    func secondaryColor() -> UIColor {
        return primaryColor().withAlphaComponent(0.2)
    }
    
}
