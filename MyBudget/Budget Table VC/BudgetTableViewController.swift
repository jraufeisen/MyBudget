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
    @IBOutlet weak var percentFillView: PercentFillView!
    
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





/// Its easier to model this vc as a plain viewcontroller, not tableviewcontroller, because I wanna ad a floating button on top
class BudgetTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var budgetCategories = [BudgetCategoryViewable]()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetCategories = Model.shared.getAllBudgetCategories()
        addFloatingActionButton()

        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        budgetCategories = Model.shared.getAllBudgetCategories()
        tableView.reloadData()
        let unbudgetedMoney = Model.shared.unbudgetedMoney()
        if unbudgetedMoney < 0 {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.expenseColor]
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.expenseColor]
            title = "Budget \(unbudgetedMoney)"
        } else if unbudgetedMoney == 0 {
            navigationController?.navigationBar.titleTextAttributes = nil
            navigationController?.navigationBar.largeTitleTextAttributes = nil
            title = "Budget"
        } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.incomeColor]
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.incomeColor]
            title = "Budget \(unbudgetedMoney)"
        }
    }
    
    var floaty = Floaty()
    private func addFloatingActionButton() {
        guard floaty.superview == nil else {
            view.bringSubviewToFront(floaty)
            return
        }

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

        //view.addSubview(floaty)
        view.addSubview(floaty)
        //tableView.superview?.addSubview(floaty)
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return budgetCategories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell") as? BudgetTableViewCell else {
            return UITableViewCell()
        }

        let category = budgetCategories[indexPath.section]

        cell.moneyLabel.text = "\(category.remainingMoney)"
        cell.categoryLabel.text = category.name
        cell.percentFillView.fillProportion = CGFloat(category.percentLeft)
        cell.detailLabel.text = category.detailString
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = budgetCategories[indexPath.section]
        let vc = BudgetDetailViewController.instantiate(with: cat)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private func addTransaction(type: TransactionType) {
        let vc = EnterNumberViewController.instantiate(with: type)
        let wrapperVC = UINavigationController.init(rootViewController: vc)
        navigationController?.present(wrapperVC, animated: true, completion: nil)
    }
    
}
