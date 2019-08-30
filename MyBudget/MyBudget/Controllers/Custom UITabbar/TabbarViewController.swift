//
//  TabbarViewController.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import CloudKit
import BLTNBoard

class TabbarViewController: UITabBarController, FloatyDelegate {

    /// Instantiate from storyboard
    internal static func instantiate() -> TabbarViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as! TabbarViewController
        return vc
    }

    lazy private var bulletinManager: BLTNItemManager = {
       
        let subscriptionPage = BulletinDataSource.makeSubscriptionPage()
        subscriptionPage.next = BulletinDataSource.makeChoicePage()
        
        let manager = BLTNItemManager(rootItem: subscriptionPage)

        return manager
    }()

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
        floaty.plusColor = tabBar.tintColor //Standard blue tint color
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
        
        item = FloatyItem()
        item.titleColor = .darkText
        item.icon = #imageLiteral(resourceName: "Logo_Only").withRenderingMode(.alwaysTemplate)
        item.title = "Subscribe"
        item.tintColor = .white
        item.buttonColor = .blueActionColor
        item.size = floaty.itemSize
        item.handler = { (item) in
            self.bulletinManager.showBulletin(above: self)
        }
        floaty.addItem(item: item)

        
        
        // Dont move - ever. Stay fixed in the tabbar
        floaty.respondsToKeyboard = false
        floaty.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floaty)
        
        // Add constraints
        let width = NSLayoutConstraint(item: floaty,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: tabBar,
                                       attribute: .height,
                                       multiplier: 0,
                                       constant: 55)
        view.addConstraint(width)
        let height = NSLayoutConstraint(item: floaty,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: tabBar,
                                        attribute: .height,
                                        multiplier: 1,
                                        constant: 5)
        view.addConstraint(height)

        
        let center_x_Constraint = NSLayoutConstraint(item: floaty,
                                            attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .centerX,
                                            multiplier: 1,
                                            constant: 0)
        view.addConstraint(center_x_Constraint)
        let center_y_Constraint = NSLayoutConstraint(item: floaty,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: tabBar,
                                                     attribute: .topMargin,
                                                     multiplier: 1,
                                                     constant: -5)
        view.addConstraint(center_y_Constraint)
        
    }
    
    // MARK: - Floating button actions
    
    private func addTransaction(type: TransactionType) {

        func show() {
            let vc = EnterNumberViewController.instantiate(with: type)
            let wrapperVC = UINavigationController.init(rootViewController: vc)
            present(wrapperVC, animated: true, completion: nil)
        }
        SwiftyStoreKit.verifyReceipt(using: ServerReceiptValidator()) { (result) in

            
            
            switch result {
                
            case .success(let receipt):
                show()
            case .error(let error):
                print("You need an active subscription to do that!")
            @unknown default:
                show()
            }

        }
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
