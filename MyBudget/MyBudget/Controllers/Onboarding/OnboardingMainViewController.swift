//
//  OnboardingMainViewController.swift
//  MyBudget
//
//  Created by Johannes on 12.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

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

    // Category selection
    @IBOutlet weak var categoriesCollectionView: UICollectionView!

    // Account creation
    @IBOutlet weak var accountHeaderView: AccountHeaderView!
    @IBOutlet weak var accountTableView: UITableView!
    
    // Money distribution
    @IBOutlet weak var budgetTitleLabel: UILabel!
    @IBOutlet weak var budgetTableView: UITableView!

    
    var delegate: OnboardingDelegate?
    
    // Data
    private var categories = [CategorySelectable]()
    private var currentlyEditedIndexPath: IndexPath?

    override func viewWillAppear(_ animated: Bool) {
        continueButton.alpha = 0 // Prepare for fade-in
        categoriesCollectionView.alpha = 0
        categoriesCollectionView.allowsMultipleSelection = true

        accountHeaderView.alpha = 0
        accountTableView.alpha = 0
        
        budgetTitleLabel.alpha = 0
        budgetTableView.alpha = 0
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
            textLabel.addTextAnimated(text: "First, decide what's important for you", timeBetweenCharacters: 0.07) {
                UIView.animate(withDuration: 0.7) {
                    self.categoriesCollectionView.alpha = 1
                }
            }
        case .categories:
            state = .accounts
            textLabel.text = ""
            textLabel.addTextAnimated(text: "Second, record your current account values", timeBetweenCharacters: 0.07) {
                UIView.animate(withDuration: 0.7) {
                    self.accountHeaderView.alpha = 1
                    self.accountTableView.alpha = 1
                }
            }
        
            UIView.animate(withDuration: 0.7, animations: {
                self.categoriesCollectionView.alpha = 0
            })
            
        case .accounts:
            state = .assignMoney
            textLabel.text = ""
            textLabel.addTextAnimated(text: "Now, create your budget", timeBetweenCharacters: 0.07) {
                UIView.animate(withDuration: 0.7) {
                    // Make distribution table visible
                    self.budgetTitleLabel.alpha = 1
                    self.budgetTableView.alpha = 1
                }

            }
            
            UIView.animate(withDuration: 0.7, animations: {
                self.accountHeaderView.alpha = 0
                self.accountTableView.alpha = 0
            })
            
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
        
        budgetTableView.register(UINib.init(nibName: "OnboardingBudgetTableViewCell", bundle: .main), forCellReuseIdentifier: OnboardingBudgetTableViewCell.Identifier)
        loadInitialData()
        // Don't forget initial reload, otherwise jumpy behavior occurs
        categoriesCollectionView.reloadData()

    }
    
    
    private func loadInitialData() {
        let categorieNames = [
            "Rent",
            "Groceries",
            "Sports",
            "School",
            "University",
            "Home",
            "Car",
            "Vacation",
            "Computer",
            "Gas",
            "Electricity",
            "Internet",
            "Phone",
            "Eating out",
            "Fun Money",
            "Gaming",
            "Gifts",
            "Clothing",
            "Mobility",
        ]
        //Calculate initial fata
        for i in 0..<categorieNames.count {
            let categorySelectable = CategorySelectable()
            categorySelectable.name = categorieNames[i]
            categories.append(categorySelectable)
        }
    }
    
    var accounts = [OnboardingAccountViewable]()
    @IBAction func pressedAccountPlusButton() {
        let newAccountVC = OnboardingNewAccountViewController.instantiate()
        newAccountVC.delegate = self
        showDetailViewController(newAccountVC, sender: nil)
    }
    
}

extension OnboardingMainViewController: OnboardingNewAccountDelegate {
    func addNewAccount(name: String, money: Money) {
        let newAccount = OnboardingAccountViewable()
        newAccount.name = name
        newAccount.money = money
        newAccount.icon = #imageLiteral(resourceName: "Piggy Bank")
        
        accounts.insert(newAccount, at: 0)
        accountTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
    }
}

class OnboardingAccountViewable {
    var icon: UIImage? = nil
    var name: String = ""
    var money: Money = 0
}

extension OnboardingMainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == accountTableView {
            return accounts.count
        } else if tableView == budgetTableView {
            return 10
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == accountTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingAccountTableViewCell.Identifier) as! OnboardingAccountTableViewCell
            
            let accountViewable = accounts[indexPath.row]
            
            cell.iconImageView.image = accountViewable.icon
            cell.leftLabel.text = accountViewable.name
            cell.rightLabel.text = "\(accountViewable.money)"
            
            return cell
        } else if tableView == budgetTableView {

            let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingBudgetTableViewCell.Identifier) as! OnboardingBudgetTableViewCell
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if tableView == accountTableView {
            if editingStyle == .delete {
                accounts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == budgetTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? OnboardingBudgetTableViewCell else {
                return
            }
           /* let keyboard = MoneyKeyboard.init(outputView: cell.moneyLabel, startingWith: 0)
            cell.moneyLabel.inputView = keyboard
            cell.moneyLabel.becomeFirstResponder()*/
            
            
            
        }
    }
    
}


class CategorySelectable {
    var name: String = ""
    var editable: Bool = false
}


extension OnboardingMainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1+categories.count // Add element at the beginning. then the categories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCategoryCollectionViewCellID", for: indexPath) as! AddCategoryCollectionViewCell
            
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCategoryCellID", for: indexPath) as! CategoryCollectionViewCell
        let item = categories[indexPath.row-1] // Shift index, cause we have add cell at beginnign
        
        cell.markEditable(editable: item.editable)
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
        
        if let _ = collectionView.cellForItem(at: indexPath) as? AddCategoryCollectionViewCell {
            let newItem = CategorySelectable()
            newItem.editable = true
            categories.insert(newItem, at: 0)
            let newIndexPath = IndexPath(row: 1, section: 0)
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: [newIndexPath])
            }) { (flag) in
                // Raise first responder
                if let newCell = collectionView.cellForItem(at: newIndexPath) as? CategoryCollectionViewCell {
                    newCell.label.becomeFirstResponder()
                    newCell.label.delegate = self
                    self.currentlyEditedIndexPath = newIndexPath
                }
            }
            
        }
        
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

extension OnboardingMainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let editedIndexPath = self.currentlyEditedIndexPath else {
            return true
        }
        
        guard let text = textField.text else {
            return true
        }
        
        if text.isEmpty == true {
            // If no text was entered, this cell shall be dismissed.
            categories.remove(at: 0)
            categoriesCollectionView.deleteItems(at: [editedIndexPath])
        } else {
            // Once editing is completed, you cannot change the cell's contents
            categories.first?.editable = false
            categories.first?.name = text
            categoriesCollectionView.reloadItems(at: [editedIndexPath])
        }
        
        currentlyEditedIndexPath = nil

        return true
    }
}

