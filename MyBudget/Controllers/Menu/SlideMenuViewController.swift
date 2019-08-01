//
//  SlideMenuViewController.swift
//  MyBudget
//
//  Created by Johannes on 01.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import SideMenu

class SlideMenuViewController: UISideMenuNavigationController {


    
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   static func instantiate() -> UISideMenuNavigationController {
        let menuTable = MenuTableViewController.instantiate()
        let sidemenu = UISideMenuNavigationController.init(rootViewController: menuTable)
        sidemenu.navigationBar.prefersLargeTitles = true
        sidemenu.leftSide = true
        sidemenu.presentationStyle = .menuSlideIn
    

        //sidemenu.presentationStyle.backgroundColor = .clear // Prevents bug with black status abr
        sidemenu.statusBarEndAlpha = 0
        return sidemenu
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

 
}
