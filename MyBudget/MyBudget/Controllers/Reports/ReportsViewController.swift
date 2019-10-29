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

        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = true
        }

        //navigationController?.extendedLayoutIncludesOpaqueBars = true
        //tableView.contentInset = UIEdgeInsets.init(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.row == 0 {
            return 250
        } else if indexPath.row == 1 {
            return 350
        }
        
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.Identifier, for: indexPath) as! PieChartTableViewCell
            cell.addChart(entries: [(400, "Rent"), (100, "Groceries"), (100, "Stuff"), (10, "More"), (20, "Beer"), (50, "More stuff")])
            cell.addChart(entries: [(10000, "Rent"), (100, "Groceries"), (100, "Stuff"), (10, "More"), (20, "Beer"), (50, "More stuff")])
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NetValueTableViewCell.Identifier, for: indexPath) as! NetValueTableViewCell
            cell.addChart(entries: [(400, "January 2019"), (100, "February 2019"), (100, "March 2019"), (10, "April 2019"), (20, "May 2019"), (50, "June 2019")])

            return cell
        }
        
        return UITableViewCell()
    }

}
