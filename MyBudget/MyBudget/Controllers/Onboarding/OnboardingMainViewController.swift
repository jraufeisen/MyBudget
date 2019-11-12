//
//  OnboardingMainViewController.swift
//  MyBudget
//
//  Created by Johannes on 12.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit


enum OnboardingState: Int {

    case welcome = 1
    case principle
    case categories
    case accounts
    case assignMoney
}

protocol OnboardingDelegate {
    func didFinishOnboarding()
}

class OnboardingMainViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var delegate: OnboardingDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        continueButton.alpha = 0 // Prepare for fade-in
    }
    
    private func setupContinueButton() {
        continueButton.backgroundColor = .blueActionColor
        continueButton.layer.cornerRadius = 20
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.shadowColor = continueButton.backgroundColor?.cgColor
        continueButton.layer.shadowRadius = 5
        continueButton.layer.shadowOffset = CGSize.init(width: 2, height: -2)
        continueButton.layer.shadowOpacity = 0.5
        continueButton.addTarget(self, action: #selector(self.pressedContinue), for: .touchUpInside)
    }
    
    @objc private func pressedContinue() {
        switch state {
        case .welcome:
            state = .principle
            textLabel.addTextAnimated(text: "\nOur principle is simple: Every penny has its job.", timeBetweenCharacters: 0.04) {
                
            }
        case .principle:
            state = .categories
            textLabel.text = ""
            textLabel.addTextAnimated(text: "First, decide what's important for you", timeBetweenCharacters: 0.07, completion: nil)
        case .categories:
            state = .accounts
            textLabel.text = ""
            textLabel.addTextAnimated(text: "Second, record your current account values", timeBetweenCharacters: 0.07, completion: nil)
        case .accounts:
            state = .assignMoney
            textLabel.text = ""
            textLabel.addTextAnimated(text: "Now, prioritize your spending categories and assign money to them", timeBetweenCharacters: 0.07, completion: nil)
        case .assignMoney: 
            delegate?.didFinishOnboarding()
        default:
            print("Whatever you say, boss")
        }
    }
    
    private var state: OnboardingState = .welcome
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContinueButton()
        
        textLabel.text = ""
        textLabel.isHidden = false
        textLabel.addTextAnimated(text: "Welcome to Budget!", timeBetweenCharacters: 0.07) {
            UIView.animate(withDuration: 0.2) {
                self.continueButton.alpha = 1 // Fade-in
            }
        }

    }
    


}
