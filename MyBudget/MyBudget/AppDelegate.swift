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
        completeStoreTransactions()
        
        ServerReceiptValidator().updateExpirationDate()

        // Prepare for UI Test and copy example data
        if ProcessInfo.processInfo.arguments.contains("UITests") {
            UIApplication.shared.keyWindow?.layer.speed = 100 // Make animations semi-instant so that UI tests can rely on fast UI changes
            loadUITestData()
        }
        
        // Communication with watch app
        WatchSessionManager.sharedManager.startSession()

        // Onboarding
        if Model.shared.ledgerFileIsEssentialyEmpty() {
            showOnboarding()
        }

        return true
    }

    private func completeStoreTransactions() {
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
    }
    
    private func loadUITestData() {
        let url = Bundle.main.url(forResource: "finances_example", withExtension: "txt")!
        let dataString = try! String.init(contentsOf: url)
        try! dataString.write(to: LedgerModel.defaultURL, atomically: true, encoding: .utf8)
    }
    
    private func showOnboarding() {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "onboardMainVCID") as! OnboardingMainViewController
        vc.delegate = self
        window?.rootViewController = vc
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        ServerReceiptValidator().updateExpirationDate()
    }

}

// MARK: OnboardingDelegate
extension AppDelegate: OnboardingDelegate {
    func didFinishOnboarding() {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        window?.rootViewController = vc
    }
}
