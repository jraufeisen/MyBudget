//
//  TabbarViewController.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController, FloatyDelegate {

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
        floaty.overlayColor = .clear // Use custom blur instead, so that tabbar stays white
        floaty.fabDelegate = self
        
        var item = FloatyItem()
        item.titleColor = .darkText
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.title = "Income"
        item.tintColor = .white
        item.buttonColor = .incomeColor
        item.size = floaty.itemSize
        item.handler = { (item) in
           self.addTransaction(type: .Income)
        }
        floaty.addItem(item: item)
        
        
        item = FloatyItem()
        item.titleColor = .darkText
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.title = "Transfer"
        item.tintColor = .white
        item.buttonColor = .transferColor
        item.size = floaty.itemSize
        item.handler = { (item) in
           self.addTransaction(type: .Transfer)
        }
        floaty.addItem(item: item)
        
        item = FloatyItem()
        item.titleColor = .darkText
        item.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        item.title = "Expense"
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




    let effectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .prominent))
    let effectViewFadeDuration = 0.2
    func floatyWillOpen(_ floaty: Floaty) {
        effectView.frame = view.frame
        effectView.alpha = 0.0
        selectedViewController?.view.addSubview(effectView)
        let animator = UIViewPropertyAnimator.init(duration: effectViewFadeDuration, curve: .easeIn) {
            self.effectView.alpha = 1.0
        }
        animator.startAnimation()
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        let animator = UIViewPropertyAnimator.init(duration: effectViewFadeDuration, curve: .easeIn) {
            self.effectView.alpha = 0.0
        }
        animator.startAnimation()
        animator.addCompletion { (position) in
            self.effectView.removeFromSuperview()
        }
    }
}
