//
//  AppDelegate.swift
//  MyBudget
//
//  Created by Johannes on 23.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import CloudKit
import Swift_Ledger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // It is recommended to add an observer here. See https://github.com/bizz84/SwiftyStoreKit#purchase-a-product-given-a-skproduct
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }

        ServerReceiptValidator().updateExpirationDate()

        
        // Prepare for UI Test and copy example data
        if ProcessInfo.processInfo.arguments.contains("UITests") {
            UIApplication.shared.keyWindow?.layer.speed = 100
            let url = Bundle.main.url(forResource: "finances_example", withExtension: "txt")!
            let dataString = try! String.init(contentsOf: url)
            try! dataString.write(to: LedgerModel.defaultURL, atomically: true, encoding: .utf8)
        }
        
        //Communication with watch app
        WatchSessionManager.sharedManager.startSession()

        
        return true
    }


    func applicationDidEnterBackground(_ application: UIApplication) {

        if let _ = window?.rootViewController as? LockScreenViewController {
        } else {
            window?.rootViewController = LockScreenViewController.instantiate()
        }
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let lockscreen = window?.rootViewController as? LockScreenViewController {
            if !lockscreen.isShowingOnboarding() {
                lockscreen.authenticateUser()
            }
        }
        
        ServerReceiptValidator().updateExpirationDate()

    }


}

