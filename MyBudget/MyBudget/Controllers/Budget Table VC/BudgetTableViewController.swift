//
//  BudgetTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 23.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import SideMenu
import Swift_Ledger

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
        
        percentFillView.tintColor = .blueActionColor
        
        selectionStyle = .none
    }
    
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

    
    static func instantiate() -> BudgetTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "budgetTableViewController") as! BudgetTableViewController
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: ModelChangedNotification, object: nil)

    }

    
    @objc private func updateUI() {
        budgetCategories = Model.shared.getAllBudgetCategories()
        if tableView.numberOfSections > 0 {
            tableView.reloadSections([0], with: .automatic)
        } else {
            tableView.reloadData()
        }
        let unbudgetedMoney = Model.shared.unbudgetedMoney()
        if unbudgetedMoney < 0 {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.expenseColor]
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.expenseColor]
            navigationItem.title = "Budget \(unbudgetedMoney.negative)"
            navigationItem.prompt = "You have overbudgeted by \(unbudgetedMoney.negative)"
        } else if unbudgetedMoney == 0 {
            navigationController?.navigationBar.titleTextAttributes = nil
            navigationController?.navigationBar.largeTitleTextAttributes = nil
            navigationItem.title = "Budget"
            navigationItem.prompt = ""
        } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.incomeColor]
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.incomeColor]
            navigationItem.title = "Budget \(unbudgetedMoney)"
            navigationItem.prompt = "You have \(unbudgetedMoney) left to budget"
        }

        

        if budgetCategories.count == 0 {
            addHelpingLabels()
        } else {
            removeHelpingLabels()
        }
        
    }
    
    let titleHelpingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 50))
    let descriptionHelpingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 50))
    private func addHelpingLabels() {
        titleHelpingLabel.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width - 60, height: 50)
        titleHelpingLabel.textAlignment = .center
        titleHelpingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleHelpingLabel.center = view.center
        titleHelpingLabel.text = "Create your own budget"
        titleHelpingLabel.translatesAutoresizingMaskIntoConstraints = false
        titleHelpingLabel.sizeToFit()
        view.addSubview(titleHelpingLabel)
        var centerX = NSLayoutConstraint.init(item: titleHelpingLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        var centerY = NSLayoutConstraint.init(item: titleHelpingLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -20)
        view.addConstraints([centerX, centerY])
        
        descriptionHelpingLabel.frame = CGRect.init(x: 0, y: titleHelpingLabel.center.y + 15, width: view.bounds.width - 60, height: 100)
        descriptionHelpingLabel.textAlignment = .center
        descriptionHelpingLabel.numberOfLines = 10
        descriptionHelpingLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionHelpingLabel.textColor = .lightGray
        descriptionHelpingLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionHelpingLabel.center = CGPoint.init(x: titleHelpingLabel.center.x, y: descriptionHelpingLabel.center.y)
        descriptionHelpingLabel.text = "Create budget categories for rent, groceries and whatever is important to you by clicking + in the top right corner"
        view.addSubview(descriptionHelpingLabel)
        
        let width = NSLayoutConstraint.init(item: descriptionHelpingLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: -60)
        let height = NSLayoutConstraint.init(item: descriptionHelpingLabel, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0, constant: 100)
        centerX = NSLayoutConstraint.init(item: descriptionHelpingLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        centerY = NSLayoutConstraint.init(item: descriptionHelpingLabel, attribute: .top, relatedBy: .equal, toItem: titleHelpingLabel, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([width, height, centerX, centerY])
    }
    
    
    private func removeHelpingLabels() {
        titleHelpingLabel.removeFromSuperview()
        descriptionHelpingLabel.removeFromSuperview()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell") as? BudgetTableViewCell else {
            return UITableViewCell()
        }

        let category = budgetCategories[indexPath.row]

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
    
    // MARK: IB Actions
    
    
    @IBAction func pressedMenuButton(_ sender: Any) {
        guard let menuPresentingController = navigationController as? MenuPresentingViewController else {
            fatalError("The presenting navigationcontroller is not a menu presenting view controller")
        }

        menuPresentingController.showMenu()
        
    }
    
    @IBAction func pressedPlusButton(_ sender: Any) {
        let newCategoryVC = NewBudgetCategoryViewController()
        let wrapperVC = UINavigationController.init(rootViewController: newCategoryVC)
        present(wrapperVC, animated: true, completion: nil)
    }
    
    
}
