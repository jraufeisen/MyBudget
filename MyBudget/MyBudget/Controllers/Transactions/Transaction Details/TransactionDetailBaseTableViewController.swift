//
//  TransactionDetailBaseTableViewController.swift
//  MyBudget
//
//  Created by Johannes on 27.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class TransactionDetailBaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Details"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(self.pressedSave))
        
        tableView.register(UINib(nibName: "EditMoneyTableViewCell", bundle: nil), forCellReuseIdentifier: "EditMoneyTableViewCell")
        tableView.register(UINib(nibName: "EditDateTableViewCell", bundle: nil), forCellReuseIdentifier: "EditDateTableViewCell")
        tableView.register(UINib(nibName: "EditNameTableViewCell", bundle: nil), forCellReuseIdentifier: "EditNameTableViewCell")
        tableView.register(UINib(nibName: "EditAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "EditAccountTableViewCell")
        tableView.register(UINib(nibName: "EditCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "EditCategoryTableViewCell")

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 66
      }
    
    @objc func pressedSave() {
        // Needs to be implemented by subclasses
    }

}
