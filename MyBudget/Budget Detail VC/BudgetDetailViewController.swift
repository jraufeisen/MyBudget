//
//  BudgetDetailViewController.swift
//  MyBudget
//
//  Created by Johannes on 28.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class BudgetDetailViewController: UITableViewController {

    @IBOutlet weak var budgetedMoneyLabel: MoneyTextField!
    @IBOutlet weak var enterNumberImageView: UIImageView!
    
    
    internal static func instantiate(with category: BudgetCategoryViewable) -> BudgetDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "budgetDetailVC") as! BudgetDetailViewController

        vc.category = category
        return vc
    }

    
    var category: BudgetCategoryViewable?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        budgetedMoneyLabel.text = ""
        let keyboard = MoneyKeyboard.init(outputView: self.budgetedMoneyLabel, startingWith: "\(category?.remainingMoney ?? 0000)".replacingOccurrences(of: ".", with: ""))
        keyboard.delegate = self
        budgetedMoneyLabel.inputView = keyboard
        
        enterNumberImageView.image = UIImage.init(named: "edit-2")?.withRenderingMode(.alwaysTemplate)
        enterNumberImageView.tintColor = .white
    }
   
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "Transaktion \(indexPath.row)"
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        budgetedMoneyLabel.resignFirstResponder()
    }
    
}

extension BudgetDetailViewController: MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        let money = keyboard.moneyEntered()
        print("I will now adjust budget to \(money)")
        budgetedMoneyLabel.resignFirstResponder()
    }
}
