//
//  TransferDetailTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 27.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

class TransferDetailTableViewController: TransactionDetailBaseTableViewController {
    
    var transaction: TransferTransaction = TransferTransaction()
    
    init(transaction: TransferTransaction) {
        self.transaction = transaction
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
        
    private var moneyCell: EditMoneyTableViewCell?
    private var dateCell: EditDateTableViewCell?
    private var nameCell: EditNameTableViewCell?
    private var fromAccountCell: EditAccountTableViewCell?
    private var toAccountCell: EditAccountTableViewCell?

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditMoneyTableViewCell.Identifier, for: indexPath) as! EditMoneyTableViewCell
            moneyCell = cell
            cell.configure(for: transaction.value)
            cell.colorStyle = .transfer
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
            fromAccountCell = cell
            fromAccountCell?.textfield.text = transaction.fromAccount
            cell.colorStyle = .transfer
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditAccountTableViewCell.Identifier, for: indexPath) as! EditAccountTableViewCell
            toAccountCell = cell
            toAccountCell?.textfield.text = transaction.toAccount
            cell.colorStyle = .transfer
            return cell
        }

        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        if cell.canBecomeFirstResponder {
            cell.becomeFirstResponder()
        }
    }
    
    override func pressedSave() {
        guard let fromAccountName = fromAccountCell?.selectedAccount() else {return}
        guard let toAccountName = toAccountCell?.selectedAccount() else {return}
        guard let description = nameCell?.selectedName() else {return}
        guard let money = moneyCell?.selectedMoney() else {return}
        guard let date = dateCell?.selectedDate() else {return}
        
        let newTx = TransferTransaction()
        newTx.fromAccount = fromAccountName
        newTx.toAccount = toAccountName
        newTx.transactionDescription = description
        newTx.value = money
        newTx.date = date
        
        LedgerModel.shared().replaceTransaction(oldTx: transaction.ledgerTransaction(), with: newTx.ledgerTransaction())
        navigationController?.popViewController(animated: true)
    }


}
