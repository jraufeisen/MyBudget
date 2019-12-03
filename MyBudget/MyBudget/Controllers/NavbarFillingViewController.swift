//
//  BaseMainViewController.swift
//  MyBudget
//
//  Created by Johannes on 03.12.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

/**
 This class's only purpos is to fill the left item of the navigation bar.
 */
class NavbarFillingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let infoBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "Info"), style: .plain, target: self, action: #selector(self.showAboutPage))
        if #available(iOS 13.0, *) {
            infoBarButton.image = UIImage.init(systemName: "info.circle")
        }
        navigationItem.leftBarButtonItem = infoBarButton
        
    }
    
    @objc private func showAboutPage() {
        let aboutVC = AboutPageViewController.instantiate()
        showDetailViewController(aboutVC, sender: nil)
    }

}
