//
//  BudgetTableHeaderViewController.swift
//  MyBudget
//
//  Created by Johannes on 26.10.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

class BudgetTableHeaderViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Configures color and text of the header label
    func configure(money: Money) {
        if money < 0 {
            label.textColor = .expenseColor
            label.text = "You have overbudgeted by \(money.negative)"
        } else if money == 0 {
           label.textColor = .black
           label.text = ""
        } else {
           label.textColor = .incomeColor
            label.text = "You have \(money) left to budget"
        }
    }
    
}
