//
//  MenuPresentingViewController.swift
//  MyBudget
//
//  Created by Johannes on 01.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import SideMenu

class MenuPresentingViewController: UINavigationController {
    
    override func viewDidLoad() {
        setupSideMenu()
    }
    
    
    func loadMenuController() -> UISideMenuNavigationController {
        // Load and configure content view controller of the menu
        let menuTable = MenuTableViewController.instantiate()
        menuTable.menuDelegate = self
        
        // Initilaize side menu controller
        let sidemenu = UISideMenuNavigationController.init(rootViewController: menuTable)
        
        sidemenu.navigationBar.prefersLargeTitles = true
        sidemenu.leftSide = true
        sidemenu.presentationStyle = .menuSlideIn
        sidemenu.menuWidth = 300
        sidemenu.presentDuration = 0.3
        sidemenu.initialSpringVelocity = 3
        sidemenu.statusBarEndAlpha = 0 // Prevents bug with black status bar
        sidemenu.presentationStyle.presentingEndAlpha = 0.5 // Dark background on presenting vc

        return sidemenu
    }

    
    
    private func setupSideMenu() {
        let menu = loadMenuController()
        //SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    
    
    
    func showMenu() {
        guard let menu = SideMenuManager.default.leftMenuNavigationController  else {
            fatalError("No menu loaded to the side menu manager")
        }
        present(menu, animated: true, completion: nil)
    }
}

extension MenuPresentingViewController: MenuSelectionDelegate {
    func didSelectMenuItem(item: MenuItem) {
        SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: nil)
        
    }
}


