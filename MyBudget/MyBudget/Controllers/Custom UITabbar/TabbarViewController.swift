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
        let floaty = SubscriptionFloaty.init(frame: CGRect(x: 0, y: 10, width: 55, height: 55))
        
        var centerButtonFrame = floaty.frame
        centerButtonFrame.origin.y = (view.bounds.height - 1.35*centerButtonFrame.height)
        centerButtonFrame.origin.x = view.bounds.width/2 - centerButtonFrame.size.width/2
        floaty.frame = centerButtonFrame
        floaty.fabDelegate = self
        

        floaty.incomeItem.handler = { (item) in
            if Model.shared.allowedToAddTransaction() {
                self.addTransaction(type: .Income)
            } else {
                self.bulletinManager.showBulletin(above: self)
            }
        }

        floaty.transferItem.handler = { (item) in
            if Model.shared.allowedToAddTransaction() {
                self.addTransaction(type: .Transfer)
            } else {
                self.bulletinManager.showBulletin(above: self)
            }
        }

        
        floaty.expenseItem.handler = { (item) in
            if Model.shared.allowedToAddTransaction() {
                self.addTransaction(type: .Expense)
            } else {
                self.bulletinManager.showBulletin(above: self)
            }
        }
        
        
        floaty.subscribeItem.handler = { (item) in
            self.bulletinManager.showBulletin(above: self)
        }
      

        
        floaty.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floaty)
        
        // Add constraints
        let width = NSLayoutConstraint(item: floaty, attribute: .width, relatedBy: .equal, toItem: tabBar, attribute: .height, multiplier: 0, constant: 55)
        view.addConstraint(width)
        let height = NSLayoutConstraint(item: floaty, attribute: .height, relatedBy: .equal, toItem: tabBar, attribute: .height, multiplier: 1, constant: 5)
        view.addConstraint(height)
        let center_x_Constraint = NSLayoutConstraint(item: floaty,  attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(center_x_Constraint)
        let center_y_Constraint = NSLayoutConstraint(item: floaty, attribute: .centerY,  relatedBy: .equal, toItem: tabBar, attribute: .topMargin, multiplier: 1, constant: -5)
        view.addConstraint(center_y_Constraint)
        
    }
    
    // MARK: - Floating button actions
    
    private func addTransaction(type: TransactionType) {

        func show() {
            let vc = EnterNumberViewController.instantiate(with: type)
            let wrapperVC = UINavigationController.init(rootViewController: vc)
            present(wrapperVC, animated: true, completion: nil)
        }
        
        show()
        
    }




    let effectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .prominent))
    let effectViewFadeDuration = 0.2
    var helpingLabel: UILabel?
    
    func floatyWillOpen(_ floaty: Floaty) {
        effectView.frame = view.frame
        effectView.alpha = 0.0
        
        helpingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: effectView.frame.width-50, height: 100))
        helpingLabel?.numberOfLines = 3
        

        DispatchQueue.global(qos: .background).async {
            let status = ServerReceiptValidator().isSubscribed()
            let remainingGlobal = Model.shared.numberOfRemainingTransactions()
            let remainingToday = Model.shared.numberOfRemainingTransactionsToday()
            DispatchQueue.main.async {
                if status {
                    self.helpingLabel?.text = "Subscribed: Unlimited access"
                    self.helpingLabel?.textColor = .incomeColor
                } else {
                    if remainingGlobal > 0 {
                        self.helpingLabel?.text = "Free version:\n\(remainingGlobal) transactions remaining"
                        self.helpingLabel?.textColor = .blueActionColor
                    } else {
                        self.helpingLabel?.text = "Free version:\n\(remainingToday) transactions remaining today"
                        self.helpingLabel?.textColor = .transferColor
                    }
                }
            }
        }
       
        helpingLabel?.center = CGPoint.init(x: effectView.center.x, y: 150)
        helpingLabel?.textAlignment = .center
        
        effectView.contentView.addSubview(helpingLabel!)
        
        selectedViewController?.view.addSubview(effectView)
        let animator = UIViewPropertyAnimator.init(duration: effectViewFadeDuration, curve: .easeIn) {
            self.effectView.alpha = 1.0
            self.helpingLabel?.alpha = 1.0
        }
        animator.startAnimation()
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        let animator = UIViewPropertyAnimator.init(duration: effectViewFadeDuration, curve: .easeIn) {
            self.effectView.alpha = 0.0
            self.helpingLabel?.alpha = 0.0
        }
        animator.startAnimation()
        animator.addCompletion { (position) in
            self.effectView.removeFromSuperview()
            self.helpingLabel?.removeFromSuperview()
        }
    }
}
