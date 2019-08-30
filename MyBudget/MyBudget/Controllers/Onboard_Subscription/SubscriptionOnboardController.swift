//
//  SubscriptionOnboardController.swift
//  MyBudget
//
//  Created by Johannes on 30.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation
import paper_onboarding

class SubscriptionOnboardController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showOnboarding()
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
        
        
        let overlayButton = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 50))
        overlayButton.setTitle(" Purchase ", for: .normal)
        overlayButton.sizeToFit()
        overlayButton.layer.borderWidth = 2
        overlayButton.layer.borderColor = UIColor.white.cgColor
        overlayButton.layer.cornerRadius = 7
        overlayButton.center = CGPoint.init(x: view.center.x, y: view.frame.height - 120)
        view.addSubview(overlayButton)

    }


    
}

extension SubscriptionOnboardController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingWillTransitonToLeaving() {
        dismiss(animated: true, completion: nil)
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "App Artwork"),
                               title: "Subscribe to unlock full access",
                               description: "You can enter up to 100 transactions while testing how Budget! works for you. We offer monthly as well as annual billing.",
                               pageIcon: UIImage(),
                               color: UIColor.blueActionColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),
            
            OnboardingItemInfo(informationImage: UIImage.bigCreditCardImage(),
                               title: "1 Month",
                               description: "If you are still not sure if Budget! is the right app for you, give it a try to another month. Just 1,49€.",
                               pageIcon: UIImage(),
                               color: UIColor.incomeColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 31 as CGFloat),
                               descriptionFont: UIFont.systemFont(ofSize: 20 as CGFloat)),
            
            OnboardingItemInfo(informationImage: UIImage.bigCreditCardImage(),
                               title: "1 Year",
                               description: "A budget is most useful when using it for a longer period of time! Buy 1-year access for 20€.",
                               pageIcon: UIImage(),
                               color: UIColor.incomeColor,
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
    

}
