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

    override func viewDidAppear(_ animated: Bool) {
        authenticateUser()
    }
    
    let onboarding = PaperOnboarding()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    @IBAction func tappedAuthenticationButton(_ sender: Any) {
        authenticateUser()
    }
    
    func authenticateUser() {
        print("Authenticating...")
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentication is needed to access your financial data."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {
            [context .evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: Error?) -> Void in
                
                if success {
                    self.showApplication()
                }  else{
                    print("Bin nicht drin")
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
        return 3
    }
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [
        
            OnboardingItemInfo(informationImage: UIImage.bagImage(),
                               title: "Every dollar has a job!",
                               description: "Budget your money in categories. So you always have your saving goals in mind!",
                               pageIcon: UIImage.bagImage(),
                               color: UIColor.incomeColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),
            
            OnboardingItemInfo(informationImage: UIImage.creditcardsImage(),
                               title: "Track your expenses",
                               description: "It just takes seconds. And it definitely pays off in the end.",
                               pageIcon: UIImage.bagImage(),
                               color: UIColor.transferColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),

            OnboardingItemInfo(informationImage: UIImage.creditcardsImage(),
                               title: "Analyze your spending behavior",
                               description: "So you always know where your money goes to.",
                               pageIcon: UIImage.bagImage(),
                               color: UIColor.expenseColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),
            ][index]

    }
    
    
    func onboardingWillTransitonToLeaving() {
        onboarding.removeFromSuperview()
    }
}
 
