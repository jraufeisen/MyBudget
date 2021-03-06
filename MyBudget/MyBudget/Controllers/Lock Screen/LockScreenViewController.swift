//
//  LockScreenViewController.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import LocalAuthentication
import paper_onboarding

fileprivate let shouldShowOnboardingKey = "shouldShowOnboarding"


class LockScreenViewController: UIViewController {
    
    /// Instantiate from storyboard
    internal static func instantiate() -> LockScreenViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LockScreenController") as! LockScreenViewController
        return vc
    }

    private func shouldShowOnboarding() -> Bool {
        if UserDefaults.standard.object(forKey: shouldShowOnboardingKey) == nil {
            UserDefaults.standard.set(true, forKey: shouldShowOnboardingKey)
        }

        return UserDefaults.standard.bool(forKey: shouldShowOnboardingKey) || Constants.shouldAlwaysShowOnboarding
    }
    let onboarding = PaperOnboarding()
    private func showOnboarding() {
        guard onboarding.superview == nil else {return}
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        UserDefaults.standard.set(false, forKey: shouldShowOnboardingKey)
        // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
             let constraint = NSLayoutConstraint(item: onboarding,
             attribute: attribute,
             relatedBy: .equal,
             toItem: view,
             attribute: attribute,
             multiplier: 1,
             constant: 0)
             view.addConstraint(constraint)
         }
    }
    func isShowingOnboarding() -> Bool {
        return onboarding.superview != nil
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldShowOnboarding() {
            showOnboarding()
        }
        
        
    }
    
    @IBAction func tappedAuthenticationButton(_ sender: Any) {
        authenticateUser()
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentication is needed to access your financial data."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) && Constants.shouldUseTouchID {
            [context .evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: Error?) -> Void in
                
                if success {
                    self.showApplication()
                }
                
            })]
        } else {
            // If the security policy cannot be evaluated then show a short message depending on the error.
            print("TouchID Nicht verfügbar")
            showApplication()
        }
    }
    

    func showApplication() {
        DispatchQueue.main.async {
            let tabbarController = TabbarViewController.instantiate()
            self.view.window?.rootViewController = tabbarController
        }
    }

}


extension LockScreenViewController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingItemsCount() -> Int {
        return 4
    }
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [
        
            OnboardingItemInfo(informationImage: UIImage.piggyBankImage(),
                               title: "Every dollar has a job!",
                               description: "Budget your money in categories. So you always have your saving goals in mind!",
                               pageIcon: UIImage(),
                               color: UIColor.incomeColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),
            
            OnboardingItemInfo(informationImage: UIImage.bigCreditCardImage(),
                               title: "Track your expenses",
                               description: "It just takes seconds and it pays off in the end!",
                               pageIcon: UIImage(),
                               color: UIColor.blueActionColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),

            OnboardingItemInfo(informationImage: UIImage.moneyTrendlineImage(),
                               title: "Analyze your spending behavior",
                               description: "So you always know where your money goes to.",
                               pageIcon: UIImage(),
                               color: UIColor.incomeColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Logo_Only"),
                               title: "Subscribe to unlock unlimited access",
                               description: "You can store up to 100 transactions for free. Afterwards, you are limited to one transactions per day.",
                               pageIcon: UIImage(),
                               color: UIColor.blueActionColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),

            ][index]

    }
    
    
    func onboardingWillTransitonToLeaving() {
        showApplication() // Do not ask for user permission here. Doing so right after presenting the "subscribe" onboarding info might awake the impression that the user needs to purchase to access the app.
    }
}
 
