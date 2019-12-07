//
//  ExpenseDetailTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 26.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

class ExpenseDetailTableViewController: TransactionDetailBaseTableViewController {

    var transaction: ExpenseTransaction = ExpenseTransaction()
    
    private var moneyCell: EditMoneyTableViewCell?
    private var dateCell: EditDateTableViewCell?
    private var nameCell: EditNameTableViewCell?
    private var accountCell: EditAccountTableViewCell?
    private var categoryCell: EditCategoryTableViewCell?
    private var tagCell: EditTagsTableViewCell?
    
    init(transaction: ExpenseTransaction) {
        self.transaction = transaction
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func pressedSave() {
        guard let accountName = accountCell?.selectedAccount() else {return}
        guard let categoryName = categoryCell?.selectedCategory() else {return}
        guard let description = nameCell?.selectedName() else {return}
        guard let money = moneyCell?.selectedMoney() else {return}
        guard let date = dateCell?.selectedDate() else {return}
        guard let tags = tagCell?.tags else {return}

        let newTx = ExpenseTransaction()
        newTx.account = accountName
        newTx.category = categoryName
        newTx.transactionDescription = description
        newTx.value = money
        newTx.date = date
        newTx.tags = tags
        
        LedgerModel.shared().replaceTransaction(oldTx: transaction.ledgerTransaction(), with: newTx.ledgerTransaction())
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension ExpenseDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditMoneyTableViewCell.Identifier, for: indexPath) as! EditMoneyTableViewCell
            moneyCell = cell
            cell.configure(for: transaction.value)
            cell.colorStyle = .expense
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditDateTableViewCell.Identifier, for: indexPath) as! EditDateTableViewCell
            dateCell = cell
            dateCell?.date = transaction.date
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditNameTableViewCell.Identifier, for: indexPath) as! EditNameTableViewCell
            nameCell = cell
            nameCell?.textfield.text = transaction.transactionDescription
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditAccountTableViewCell.Identifier, for: indexPath) as! EditAccountTableViewCell
            accountCell = cell
            accountCell?.textfield.text = transaction.account
            cell.colorStyle = .expense
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditCategoryTableViewCell.Identifier, for: indexPath) as! EditCategoryTableViewCell
            categoryCell = cell
            categoryCell?.textfield.text = transaction.category
            cell.colorStyle = .expense
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditTagsTableViewCell.Identifier, for: indexPath) as! EditTagsTableViewCell
            tagCell = cell
            cell.tags = transaction.tags
            cell.colorStyle = .expense
            cell.tagField.onDidChangeHeightTo = { (field, height) in
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            return cell
        }

        return UITableViewCell()
    }

}


// MARK: - UITableViewDelegate
extension ExpenseDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        if cell.canBecomeFirstResponder {
            cell.becomeFirstResponder()
        }
    }
    
}
