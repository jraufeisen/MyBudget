//
//  ReportsViewController.swift
//  MyBudget
//
//  Created by Johannes on 27.10.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PieChartTableViewCell", bundle: nil), forCellReuseIdentifier: PieChartTableViewCell.Identifier)
        tableView.register(UINib(nibName: "NetValueTableViewCell", bundle: nil), forCellReuseIdentifier: NetValueTableViewCell.Identifier)
        tableView.register(UINib(nibName: "IncomeStatementTableViewCell", bundle: nil), forCellReuseIdentifier: IncomeStatementTableViewCell.Identifier)

        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = true
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return 250
        } else if indexPath.row == 1 {
            return 350
        } else if indexPath.row == 2 {
            return 250
        }
        
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.Identifier, for: indexPath) as! PieChartTableViewCell

            DispatchQueue.global().async {
                let spendings = Model.shared.getMonthlySpendings()
                DispatchQueue.main.async {
                    cell.data = spendings
                }
            }
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NetValueTableViewCell.Identifier, for: indexPath) as! NetValueTableViewCell

            DispatchQueue.global().async {
                let netValues = Model.shared.getNetValueReport()
                DispatchQueue.main.async {
                    cell.data = netValues
                }
            }

            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomeStatementTableViewCell.Identifier, for: indexPath) as! IncomeStatementTableViewCell
            cell.reset()
            cell.addChart(income: 400, expense: 200, label: "October 2019")
            cell.addChart(income: 100, expense: 200, label: "November 2019")

            return cell
        }
        
        return UITableViewCell()
    }

    
}
