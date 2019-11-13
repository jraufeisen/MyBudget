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
    @IBOutlet weak var categoriesCollectionView: UICollectionView!

    var delegate: OnboardingDelegate?
    
    // Data
    private var categories = [CategorySelectable]()
    
    override func viewWillAppear(_ animated: Bool) {
        continueButton.alpha = 0 // Prepare for fade-in
        categoriesCollectionView.alpha = 0
        categoriesCollectionView.allowsMultipleSelection = true
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
            UIView.animate(withDuration: 0.7) {
                self.categoriesCollectionView.alpha = 1
            }
        case .categories:
            state = .accounts
            textLabel.text = ""
            textLabel.addTextAnimated(text: "Second, record your current account values", timeBetweenCharacters: 0.07, completion: nil)
            UIView.animate(withDuration: 0.7) {
                self.categoriesCollectionView.alpha = 0
            }
        case .accounts:
            state = .assignMoney
            textLabel.text = ""
            textLabel.addTextAnimated(text: "Now, prioritize your spending categories and assign money to them", timeBetweenCharacters: 0.07, completion: nil)
        case .assignMoney: 
            delegate?.didFinishOnboarding()
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
        
        //Calculate initial fata
        for _ in 0..<100 {
            let categorySelectable = CategorySelectable()
            categorySelectable.name = "Category"
            categories.append(categorySelectable)
        }
        // Don't forget initial reload, otherwise jumpy behavior occurs
        categoriesCollectionView.reloadData()

    }
    
}

class CategorySelectable {
    var name: String = "test"
}


extension OnboardingMainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCategoryCellID", for: indexPath) as! CategoryCollectionViewCell
        let item = categories[indexPath.row]

        cell.markSelected(selected: cell.isSelected)
        cell.label.text = item.name
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.markSelected(selected: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.markSelected(selected: false)
        }
    }
    
    
}
