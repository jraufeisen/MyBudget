//
//  BudgetDetailViewController.swift
//  MyBudget
//
//  Created by Johannes on 28.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class CategoryTransacitonCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        moneyLabel.textColor = .expenseColor
        selectionStyle = .none
    }
}


class BudgetDetailViewController: UITableViewController {

    @IBOutlet weak var unbudgetedMoneyLabel: UILabel!
    @IBOutlet weak var budgetedMoneyLabel: MoneyTextField!
    @IBOutlet weak var enterNumberImageView: UIImageView!
    
    
    internal static func instantiate(with category: BudgetCategoryViewable) -> BudgetDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "budgetDetailVC") as! BudgetDetailViewController

        vc.category = category
        return vc
    }

    
    var category: BudgetCategoryViewable?
    var transactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        title = category?.name
        
        // Adjust money label
        budgetedMoneyLabel.text = ""

        let keyboard = MoneyKeyboard.init(outputView: self.budgetedMoneyLabel, startingWith: category?.remainingMoney.minorUnits ?? 0)
        
        keyboard.delegate = self
        budgetedMoneyLabel.inputView = keyboard
        budgetedMoneyLabel.delegate = self
        
        // Adjust image view
        enterNumberImageView.image = UIImage.init(named: "edit-2")?.withRenderingMode(.alwaysTemplate)
        enterNumberImageView.tintColor = .white
        
        // Load data
        if let cat = category {
            transactions = Model.shared.transactions(for: cat.name)
        }
        
        updateUnbudgetedLabel()
    }
   
    
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? CategoryTransacitonCell else {
            return UITableViewCell()
        }
        let tx = transactions[indexPath.row]
        
        cell.nameLabel.text = tx.transactionDescription
        cell.moneyLabel.text = "\(tx.value)"
        
        guard let expenseTx = tx as? ExpenseTransaction else {
            return cell
        }
        cell.accountLabel.text = expenseTx.account
        let localizedDateString = DateFormatter.localizedString(from: expenseTx.date, dateStyle: .medium, timeStyle: .none)
        cell.dateLabel.text = localizedDateString
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        budgetedMoneyLabel.resignFirstResponder()
    }
    
}

extension BudgetDetailViewController: MoneyKeyBoardDelegate {
    func moneyKeyboardPressedDone(keyboard: MoneyKeyboard) {
        guard let cat = self.category?.name else {return}
        let money = keyboard.moneyEntered()
        Model.shared.setBudget(category: cat, newValue: money)
        budgetedMoneyLabel.resignFirstResponder()
    }
}

extension BudgetDetailViewController: UITextFieldDelegate {
    func updateUnbudgetedLabel() {
        unbudgetedMoneyLabel.text = "\(Model.shared.unbudgetedMoney())"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateUnbudgetedLabel()
    }
}
