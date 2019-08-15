//
//  TabbarViewController.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCenterButton()
    }
    

    

    func setupCenterButton() {
        let floaty = Floaty.init(frame: CGRect(x: 0, y: 10, width: 55, height: 55))
        
        var centerButtonFrame = floaty.frame
        centerButtonFrame.origin.y = (view.bounds.height - 1.35*centerButtonFrame.height)
        centerButtonFrame.origin.x = view.bounds.width/2 - centerButtonFrame.size.width/2
        floaty.frame = centerButtonFrame
        
        floaty.buttonColor = .white
        floaty.plusColor = .blue
        floaty.itemSize = 50
        
        var item = FloatyItem()
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.tintColor = .white
        item.buttonColor = .incomeColor
        item.size = floaty.itemSize
        item.handler = { (item) in
           self.addTransaction(type: .Income)
        }
        floaty.addItem(item: item)
        
        
        item = FloatyItem()
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.tintColor = .white
        item.buttonColor = .transferColor
        item.size = floaty.itemSize
        item.handler = { (item) in
           self.addTransaction(type: .Transfer)
        }
        floaty.addItem(item: item)
        
        item = FloatyItem()
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.tintColor = .white
        item.buttonColor = .expenseColor
        item.size = floaty.itemSize
        item.handler = { (item) in
            self.addTransaction(type: .Expense)
        }
        floaty.addItem(item: item)
        
        // Dont move - ever. Stay fixed in the tabbar
        floaty.respondsToKeyboard = false
        
        view.addSubview(floaty)
        view.layoutIfNeeded()
        
    }
    
    // MARK: - Floating button actions
    
    private func addTransaction(type: TransactionType) {
        let vc = EnterNumberViewController.instantiate(with: type)
        let wrapperVC = UINavigationController.init(rootViewController: vc)
        present(wrapperVC, animated: true, completion: nil)
    }


}
