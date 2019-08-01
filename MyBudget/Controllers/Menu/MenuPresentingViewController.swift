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
    let darkOverlayView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    func showMenu() {
        guard let menu = SideMenuManager.default.leftMenuNavigationController  else {
            fatalError("No menu loaded to the side menu manager")
        }

        menu.sideMenuDelegate = self
        present(menu, animated: true, completion: nil)

    }
    
    
    
}
extension MenuPresentingViewController: UISideMenuNavigationControllerDelegate {
   
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        darkOverlayView.backgroundColor = .black
        darkOverlayView.alpha = 0.5
        view.addSubview(darkOverlayView)
    }
    
  
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        darkOverlayView.removeFromSuperview()
    }
   
}
