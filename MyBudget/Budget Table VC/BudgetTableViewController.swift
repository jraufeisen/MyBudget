//
//  BudgetTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 23.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit


class BudgetTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var insetView: UIView!
    

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        insetView.layer.borderWidth = 1
        insetView.layer.borderColor = UIColor.lightGray.cgColor
        insetView.layer.cornerRadius = 10
        insetView.layer.masksToBounds = true
        
        selectionStyle = .none
    }
    
}




enum TransactionType {
    case Income
    case Expense
    case Transfer
}

///This struct will be used to pass relevant context information to upfollowing interface controllers
public struct EntryContext {
    var type: TransactionType?
    var money: String?
    var account: String?
    var budgetCategory: String?
    var description: String?
    
    init(type: TransactionType? = nil, money: String? = nil, account: String? = nil, budgetCategory: String? = nil, description: String? = nil) {
        self.type = type
        self.money = money
        self.account = account
        self.budgetCategory = budgetCategory
        self.description = description
    }

    
}






class BudgetTableViewController: UITableViewController {

    private var budgetCategories = [BudgetCategoryViewable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetCategories = Model.shared.getAllBudgetCategories()

    }
    override func viewDidAppear(_ animated: Bool) {
        addFloatingActionButton()
        budgetCategories = Model.shared.getAllBudgetCategories()
        tableView.reloadData()
    }
    
    private func addFloatingActionButton() {
        let floaty = Floaty()
        floaty.buttonColor = .white
        floaty.plusColor = .blue
        floaty.itemSize = 50

        var item = FloatyItem()
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.tintColor = .white
        item.buttonColor = .incomeColor
        item.size = floaty.itemSize
        item.handler = { (item) in
            self.addTransaction(type: .Income)
        }
        floaty.addItem(item: item)

        
        item = FloatyItem()
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.tintColor = .white
        item.buttonColor = .transferColor
        item.size = floaty.itemSize
        item.handler = { (item) in
            self.addTransaction(type: .Transfer)
        }
        floaty.addItem(item: item)

        item = FloatyItem()
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.tintColor = .white
        item.buttonColor = .expenseColor
        item.size = floaty.itemSize
        item.handler = { (item) in
            self.addTransaction(type: .Expense)
        }
        floaty.addItem(item: item)

        

        tableView.superview?.addSubview(floaty)
    }
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return budgetCategories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell") as? BudgetTableViewCell else {
            return UITableViewCell()
        }

        let category = budgetCategories[indexPath.section]

        cell.moneyLabel.text = "\(category.remainingMoney)"
        cell.categoryLabel.text = category.name
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = budgetCategories[indexPath.section]
        let vc = BudgetDetailViewController.instantiate(with: cat)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private func addTransaction(type: TransactionType) {
        let vc = EnterNumberViewController.instantiate(with: type)
        //navigationController?.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
