//
//  AccountTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 03.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

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
    
    @objc private func updateModel() {
        incomestatement = Model.shared.getIncomeStatementViewable()
        accounts = Model.shared.getAllAccountViewables()
        tableView.reloadData()
        
        if accounts.count == 0 {
            addHelpingLabels()
        } else {
            removeHelpingLabels()
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if accounts.isEmpty {return 0} // No extra cell for total income statement
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
        updateModel()
        navigationItem.title = "Accounts"
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateModel), name: ModelChangedNotification, object: nil)
    }

    
    let titleHelpingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 50))
    let descriptionHelpingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 50))
    private func addHelpingLabels() {
        titleHelpingLabel.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width - 60, height: 50)
        titleHelpingLabel.textAlignment = .center
        titleHelpingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleHelpingLabel.center = view.center
        titleHelpingLabel.text = "Add your banking accounts"
        titleHelpingLabel.sizeToFit()
        titleHelpingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleHelpingLabel)
        var centerX = NSLayoutConstraint.init(item: titleHelpingLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        var centerY = NSLayoutConstraint.init(item: titleHelpingLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -20)
        view.addConstraints([centerX, centerY])

        
        descriptionHelpingLabel.frame = CGRect.init(x: 0, y: titleHelpingLabel.center.y + 15, width: view.bounds.width - 60, height: 100)
        descriptionHelpingLabel.textAlignment = .center
        descriptionHelpingLabel.numberOfLines = 10
        descriptionHelpingLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionHelpingLabel.textColor = .lightGray
        descriptionHelpingLabel.center = CGPoint.init(x: titleHelpingLabel.center.x, y: descriptionHelpingLabel.center.y)
        descriptionHelpingLabel.text = "Add a new account by clicking + in the top right corner"
        descriptionHelpingLabel.translatesAutoresizingMaskIntoConstraints = false
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

    
    
    
    
    @IBAction func pressedMenu(_ sender: Any) {
        guard let menuPresentingController = navigationController as? MenuPresentingViewController else {
            fatalError("The presenting navigationcontroller is not a menu presenting view controller")
        }
        
        menuPresentingController.showMenu()
    }
    
    
    @IBAction func pressedPlus(_ sender: Any) {
        let newAccountVC = NewAccountViewController()
        let wrapperVC = UINavigationController.init(rootViewController: newAccountVC)
        present(wrapperVC, animated: true, completion: nil)
    }
}

