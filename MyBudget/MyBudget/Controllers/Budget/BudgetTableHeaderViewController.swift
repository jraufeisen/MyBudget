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
    
    class func instantiate() -> BudgetTableHeaderViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BudgetTableHeaderViewControllerIdentifier") as! BudgetTableHeaderViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Configures color and text of the header label
    func configure(money: Money) {
        if money < 0 {
            label.textColor = .expenseColor
            label.text = String(format: NSLocalizedString("You have overbudgeted by %@", comment: "%@ stands for a monetary amount"), "\(money.negative)")
        } else if money == 0 {
            label.textColor = .black
            label.text = ""
        } else {
            label.textColor = .incomeColor
            label.text = String(format: NSLocalizedString("You have %@ left to budget", comment: "%@ stands for a monetary amount"), "\(money)")
        }
    }
    
}
