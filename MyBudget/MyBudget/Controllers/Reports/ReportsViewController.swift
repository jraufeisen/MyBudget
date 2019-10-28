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
        return 1
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.Identifier, for: indexPath) as! PieChartTableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTableViewCellID") as! PieChartTableViewCell
        

        print(cell.frame)
        print(cell.chartContainer.frame)
        cell.addChart(entries: [(400, "Rent"), (100, "Groceries"), (100, "Stuff"), (10, "More"), (20, "Beer"), (50, "More stuff")])
        cell.addChart(entries: [(10000, "Rent"), (100, "Groceries"), (100, "Stuff"), (10, "More"), (20, "Beer"), (50, "More stuff")])

        
        return cell
    }

}
