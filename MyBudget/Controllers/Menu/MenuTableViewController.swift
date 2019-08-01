//
//  MenuViewController.swift
//  MyBudget
//
//  Created by Johannes on 01.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

/// Tableview with the actual contents
class MenuTableViewController: UITableViewController {

    
    /// Use this method to configure the View controller appropriately.
    internal static func instantiate() -> MenuTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuTableViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
