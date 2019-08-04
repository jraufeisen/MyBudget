//
//  AccountTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 03.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit


class IncomeStatementCell : UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var insetView: UIView!

    @IBOutlet weak var incomeFillView: IncomeStatementPercentView!
    @IBOutlet weak var expenseFillView: IncomeStatementPercentView!
    
    override func awakeFromNib() {
        insetView.layer.borderWidth = 1
        insetView.layer.borderColor = UIColor.lightGray.cgColor
        insetView.layer.cornerRadius = 10
        insetView.layer.masksToBounds = true
        selectionStyle = .none
    }

    
}


class IncomeStatementAccountCell: UITableViewCell {
    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var incomeFillView: IncomeStatementPercentView!
    @IBOutlet weak var expenseFillView: IncomeStatementPercentView!
    
    override func awakeFromNib() {
        insetView.layer.borderWidth = 1
        insetView.layer.borderColor = UIColor.lightGray.cgColor
        insetView.layer.cornerRadius = 10
        insetView.layer.masksToBounds = true
        selectionStyle = .none
    }
    
}





/// Its easier to model this vc as a plain viewcontroller, not tableviewcontroller, because I wanna ad a floating button on top
class AccountTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var incomestatement: IncomeStatementViewable = Model.shared.getIncomeStatementViewable()
    private var accounts: [AccountViewable] = Model.shared.getAllAccountViewables()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // First cell is an overall summary cell
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "incomeStatementCell") as? IncomeStatementCell else {
                return UITableViewCell()
            }
            
            cell.incomeFillView.overlayText = "\(incomestatement.earnedThisMonth)"
            cell.expenseFillView.overlayText = "\(incomestatement.spentThisMonth)"

            //Calculate percentages
            let totalActivity = (incomestatement.earnedThisMonth+incomestatement.spentThisMonth)
            if totalActivity.minorUnits == 0 {
                cell.incomeFillView.fillProportion = 0
                cell.expenseFillView.fillProportion = 0
            } else {
                cell.incomeFillView.fillProportion = CGFloat( (incomestatement.earnedThisMonth).floatValue/(totalActivity).floatValue )
                cell.expenseFillView.fillProportion = CGFloat( (incomestatement.spentThisMonth).floatValue/(totalActivity).floatValue )
            }
            
            return cell
        }
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "incomeStatemenetAccountCell") as? IncomeStatementAccountCell else {
            return UITableViewCell()
        }
        let viewable = accounts[indexPath.row-1]
        cell.accountLabel.text = viewable.name
        cell.moneyLabel.text = "\(viewable.remainingMoney)"
        cell.incomeFillView.overlayText = "\(viewable.earnedThisMonth)"
        cell.expenseFillView.overlayText = "\(viewable.spentThisMonth)"

        //Calculate percentages
        let totalActivity = (viewable.earnedThisMonth+viewable.spentThisMonth)
        if totalActivity.minorUnits == 0 {
            cell.incomeFillView.fillProportion = 0
            cell.expenseFillView.fillProportion = 0
        } else {
            cell.incomeFillView.fillProportion = CGFloat( (viewable.earnedThisMonth).floatValue/(totalActivity).floatValue )
            cell.expenseFillView.fillProportion = CGFloat( (viewable.spentThisMonth).floatValue/(totalActivity).floatValue )
        }

        return cell
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
    

    @IBOutlet var tableView: UITableView!

    
    internal static func instantiate() -> AccountTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountsViewController") as! AccountTableViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Accounts"
    }

    @IBAction func pressedMenu(_ sender: Any) {
        guard let menuPresentingController = navigationController as? MenuPresentingViewController else {
            fatalError("The presenting navigationcontroller is not a menu presenting view controller")
        }
        
        menuPresentingController.showMenu()
    }
}

