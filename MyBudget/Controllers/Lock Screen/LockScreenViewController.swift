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

class LockScreenViewController: UIViewController {
    /// Instantiate from storyboard
    internal static func instantiate() -> LockScreenViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LockScreenController") as! LockScreenViewController
        return vc
    }

    private func shouldShowOnboarding() -> Bool {
        return arc4random() % 10 < 5
    }
    let onboarding = PaperOnboarding()
    private func showOnboarding() {
        guard onboarding.superview == nil else {return}
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
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
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {
            [context .evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: Error?) -> Void in
                
                if success {
                    self.showApplication()
                }
                
            })]
        }
        else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            print("Nicht verfügbar")
            showApplication()
        }
    }
    

    func showApplication() {
        DispatchQueue.main.sync {
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
                               color: UIColor.transferColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),

            OnboardingItemInfo(informationImage: UIImage.moneyTrendlineImage(),
                               title: "Analyze your spending behavior",
                               description: "So you always know where your money goes to.",
                               pageIcon: UIImage(),
                               color: UIColor.expenseColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Security Shield"),
                               title: "Your data stays safe",
                               description: "We use Touch ID to authenticate you",
                               pageIcon: UIImage(),
                               color: UIColor.transferColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),

            ][index]

    }
    
    
    func onboardingWillTransitonToLeaving() {
        authenticateUser()
    }
}
 
