//
//  ExpenseDetailTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 26.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class ExpenseDetailTableViewController: UITableViewController {

    private var transaction: ExpenseTransaction = ExpenseTransaction()
    
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    class func instantiate(for transaction: ExpenseTransaction) -> ExpenseDetailTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpenseDetailsVC") as! ExpenseDetailTableViewController
        vc.transaction = transaction
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.register(UINib(nibName: "EditMoneyTableViewCell", bundle: nil), forCellReuseIdentifier: "EditMoneyTableViewCell")
        tableView.register(UINib(nibName: "EditDateTableViewCell", bundle: nil), forCellReuseIdentifier: "EditDateTableViewCell")
        tableView.register(UINib(nibName: "EditNameTableViewCell", bundle: nil), forCellReuseIdentifier: "EditNameTableViewCell")
        tableView.register(UINib(nibName: "EditAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "EditAccountTableViewCell")
        tableView.register(UINib(nibName: "EditCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "EditCategoryTableViewCell")

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditMoneyTableViewCell", for: indexPath) as! EditMoneyTableViewCell
            cell.configure(for: transaction.value)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditDateTableViewCell", for: indexPath) as! EditDateTableViewCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditNameTableViewCell", for: indexPath) as! EditNameTableViewCell
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditAccountTableViewCell", for: indexPath) as! EditAccountTableViewCell
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCategoryTableViewCell", for: indexPath) as! EditCategoryTableViewCell
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
    
}
