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

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.Identifier, for: indexPath) as! PieChartTableViewCell

        return cell
    }

}
