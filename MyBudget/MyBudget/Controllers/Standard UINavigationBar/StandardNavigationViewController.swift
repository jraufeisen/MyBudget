//
//  StandardNavigationViewController.swift
//  MyBudget
//
//  Created by Johannes on 24.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class StandardNavigationViewController: UINavigationController {

    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupView() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            navBarAppearance.backgroundColor = UIColor.systemBackground
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
}
