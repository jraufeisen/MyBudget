//
//  IncomeStatementCard.swift
//  MyBudget
//
//  Created by Johannes on 29.10.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class IncomeStatementCard: UIView {
    
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var chartContainer: UIView!
     @IBOutlet weak var contentView: UIView!
     
    @IBOutlet weak var incomeAmountLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!

     override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }
     
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         commonInit()
     }
     
     private func commonInit() {
         Bundle.main.loadNibNamed("IncomeStatementCard", owner: self, options: nil)
         addSubview(contentView)
         contentView.frame = self.bounds
         contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         if #available(iOS 13.0, *) {
             contentView.backgroundColor = .secondarySystemBackground
         } else {
             contentView.backgroundColor = UIColor.lightGray
         }

        
         layer.cornerRadius = 10
         contentView.layer.cornerRadius = 10
         
         layer.shadowColor = UIColor.init(white: 0, alpha: 1).cgColor
         layer.shadowRadius = 5
         layer.shadowOffset = CGSize.init(width: 2, height: 5)
         layer.shadowOpacity = 0.3

     }


}
