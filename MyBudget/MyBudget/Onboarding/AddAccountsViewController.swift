//
//  AddAccountsViewController.swift
//  MyBudget
//
//  Created by Johannes on 30.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class AddAccountsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    private var accounts = ["Banking", "Cash", "Savings", "Accounts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .transferColor
        imageView.image = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
    }

}
