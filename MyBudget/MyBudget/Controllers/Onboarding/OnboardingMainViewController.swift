//
//  OnboardingMainViewController.swift
//  MyBudget
//
//  Created by Johannes on 12.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger
import MaterialComponents.MaterialProgressView

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

class OnboardingAccountViewable {
    var icon: UIImage? = nil
    var name: String = ""
    var money: Money = 0
}

// MARK: - OnboardingMainViewController
class OnboardingMainViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!

    // Category selection
    @IBOutlet weak var categoriesCollectionView: UICollectionView!

    // Account creation
    @IBOutlet weak var accountHeaderView: AccountHeaderView!
    @IBOutlet weak var accountContainerView: UIView!
    
    // Money distribution
    @IBOutlet weak var budgetTitleLabel: UILabel!
    @IBOutlet weak var budgetTableView: UITableView!

    // UI flag to prevent overlapping states
    private var animationInProgress: Bool = false {
        didSet {
            updateContinueButtonState()
        }
    }
    
    @IBOutlet weak var progressView: MDCProgressView!
    
    var delegate: OnboardingDelegate?
    
    // Data
    private var categories = [CategorySelectable]()
    private var currentlyEditedIndexPath: IndexPath?

    // Embedded view controllers
    private var accountTableViewController: OnboardingAccountTableViewController?
    
    // Current UI status
    private var state: OnboardingState = .welcome
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEmbedAccountTableViewController" {
            accountTableViewController = (segue.destination as! OnboardingAccountTableViewController)
            accountTableViewController?.delegate = self
        }
    }
    
    private func colorForProgress(progress: Float) -> UIColor? {
        return UIColor.blueActionColor.withAlphaComponent(1).interpolateRGBColorTo(.incomeColor, fraction: CGFloat(progress))
    }
    
    private func currentProgressColor() -> UIColor? {
        return colorForProgress(progress: progressView.progress)
    }
    
    private func selectedCategories() -> [CategorySelectable] {
        return categories.filter { (category) -> Bool in
            return category.selected
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        continueButton.alpha = 0 // Prepare for fade-in
        categoriesCollectionView.alpha = 0
        categoriesCollectionView.allowsMultipleSelection = true

        accountHeaderView.alpha = 0
        accountContainerView.alpha = 0
        
        budgetTitleLabel.alpha = 0
        budgetTableView.alpha = 0
        progressView.progress = 0
        progressView.trackTintColor = .groupTableViewBackground
    }
    
    private func setupContinueButton() {
        continueButton.backgroundColor = .blueActionColor
        continueButton.layer.cornerRadius = 20
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.addTarget(self, action: #selector(self.pressedContinue), for: .touchUpInside)
    }
    
    @objc private func pressedContinue() {
        animationInProgress = true
        switch state {
        case .welcome:
            state = .principle

            textLabel.addTextAnimated(text: NSLocalizedString("\nOur principle is simple: Every penny has its job.", comment: ""), animationDuration: 2.1) {
                self.animationInProgress = false
            }

        case .principle:
            state = .categories
            textLabel.text = ""
            self.progressView.setProgress(1/4, animated: true) { (flag) in
                self.categoriesCollectionView.reloadData()
                self.continueButton.backgroundColor = self.currentProgressColor()
            }
            self.progressView.progressTintColor = colorForProgress(progress: 1/4)
            
            animateContinueButton(visible: false)
            textLabel.addTextAnimated(text: NSLocalizedString("First, decide what's important for you", comment: ""), animationDuration: 2.0) {
                UIView.animate(withDuration: 0.7, animations: {
                    self.categoriesCollectionView.alpha = 1
                }) { (flag) in
                    self.animationInProgress = false
                }
            }

        case .categories:
            state = .accounts
            self.progressView.setProgress(2/4, animated: true) { (flag) in
                self.accountHeaderView.backgroundColor = self.currentProgressColor()
                self.continueButton.backgroundColor = self.currentProgressColor()
            }
            self.progressView.progressTintColor = colorForProgress(progress: 2/4)
            textLabel.text = ""
            animateContinueButton(visible: false)
            textLabel.addTextAnimated(text: NSLocalizedString("Second, record your current account values", comment: ""), animationDuration: 2.0) {
                UIView.animate(withDuration: 0.7, animations: {
                    self.accountHeaderView.alpha = 1
                    self.accountContainerView.alpha = 1
                }) { (flag) in
                    self.animationInProgress = false
                }
            }
        
            UIView.animate(withDuration: 0.7, animations: {
                self.categoriesCollectionView.alpha = 0
            })
        case .accounts:
            state = .assignMoney
            self.progressView.setProgress(3/4, animated: true) { (flag) in
                self.continueButton.backgroundColor = self.currentProgressColor()
            }
            self.progressView.progressTintColor = colorForProgress(progress: 3/4)
            reloadHeader()
            textLabel.text = ""
            budgetTableView.reloadData()
            textLabel.addTextAnimated(text: NSLocalizedString("Now, create your budget", comment: ""), animationDuration: 1.0) {
                UIView.animate(withDuration: 0.7, animations: {
                    // Make distribution table visible
                    self.budgetTitleLabel.alpha = 1
                    self.budgetTableView.alpha = 1
                }) { (flag) in
                    self.animationInProgress = false
                }
            }
            
            UIView.animate(withDuration: 0.7, animations: {
                self.accountHeaderView.alpha = 0
                self.accountContainerView.alpha = 0
            })
            
        case .assignMoney: 
            self.progressView.progressTintColor = colorForProgress(progress: 4/4)
            self.progressView.setProgress(4/4, animated: true) { (flag) in
                // Save to ledger. But check that you dont overwrite anything
                guard let accounts = self.accountTableViewController?.accounts else {
                    return
                }
                Model.shared.createInitialBudget(accounts: accounts, categories: self.selectedCategories())
                self.delegate?.didFinishOnboarding()
            }
        }

        updateContinueButtonState()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContinueButton()
        textLabel.text = ""
        textLabel.isHidden = false
        textLabel.addTextAnimated(text: NSLocalizedString("Welcome to Budget!", comment: ""), animationDuration: 1.0) {
            UIView.animate(withDuration: 0.2) {
                self.continueButton.alpha = 1 // Fade-in
            }
        }
        budgetTableView.register(UINib.init(nibName: "OnboardingBudgetTableViewCell", bundle: .main), forCellReuseIdentifier: OnboardingBudgetTableViewCell.Identifier)
        loadInitialData()
        // Don't forget initial reload, otherwise jumpy behavior occurs
        categoriesCollectionView.reloadData()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGroupedBackground
            categoriesCollectionView.backgroundColor = .systemGroupedBackground
            budgetTableView.backgroundColor = .systemGroupedBackground
        }
    }
    
    private func loadInitialData() {
        categories.append(CategorySelectable.init(name: NSLocalizedString("Rent", comment: ""), icon: #imageLiteral(resourceName: "icons8-house-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Groceries", comment: ""), icon: #imageLiteral(resourceName: "icons8-food-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Sports", comment: ""), icon: #imageLiteral(resourceName: "icons8-soccer-player-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("School", comment: ""), icon: #imageLiteral(resourceName: "icons8-school-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("University", comment: ""), icon: #imageLiteral(resourceName: "icons8-school-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Home", comment: ""), icon: #imageLiteral(resourceName: "icons8-house-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Car", comment: ""), icon: #imageLiteral(resourceName: "icons8-police-car-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Vacation", comment: ""), icon: #imageLiteral(resourceName: "icons8-beach-umbrella-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Computer", comment: ""), icon: #imageLiteral(resourceName: "icons8-computer-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Gas", comment: ""), icon: #imageLiteral(resourceName: "icons8-gas-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Electricity", comment: ""), icon: #imageLiteral(resourceName: "icons8-conflict-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Internet", comment: ""), icon: #imageLiteral(resourceName: "icons8-computer-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Phone", comment: ""), icon: #imageLiteral(resourceName: "icons8-iphone-x-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Eating out", comment: ""), icon: #imageLiteral(resourceName: "icons8-food-truck-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Party", comment: ""), icon: #imageLiteral(resourceName: "Image-1")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Gaming", comment: ""), icon: #imageLiteral(resourceName: "icons8-game-controller-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Gifts", comment: ""), icon: #imageLiteral(resourceName: "icons8-christmas-gift-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Clothing", comment: ""), icon: #imageLiteral(resourceName: "icons8-changing-room-50")))
        categories.append(CategorySelectable.init(name: NSLocalizedString("Mobility", comment: ""), icon: #imageLiteral(resourceName: "Image")))
    }
    
    @IBAction func pressedAccountPlusButton() {
        let newAccountVC = OnboardingNewAccountViewController.instantiate()
        newAccountVC.delegate = self.accountTableViewController
        showDetailViewController(newAccountVC, sender: nil)
    }
    
}

extension OnboardingMainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == budgetTableView {
            return selectedCategories().count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == budgetTableView {

            let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingBudgetTableViewCell.Identifier) as! OnboardingBudgetTableViewCell
            let selectedCategory = selectedCategories()[indexPath.row]
            cell.iconImageView.image = selectedCategory.icon.withRenderingMode(.alwaysTemplate)
            cell.accountLabel.text = selectedCategory.name
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Automatically begin editing the cell
        if tableView == budgetTableView {
            if let cell = budgetTableView.cellForRow(at: indexPath) as? OnboardingBudgetTableViewCell {
                cell.moneyTextField.becomeFirstResponder()
            }
        }
        
    }
    
}


class CategorySelectable {
    
    var name: String = ""
    var editable: Bool = false
    var selected: Bool = false
    var assignedMoney: Money = 0
    var icon: UIImage = #imageLiteral(resourceName: "Bag")
    
    init(name: String = "", icon: UIImage = #imageLiteral(resourceName: "Bag")) {
        self.name = name
        self.icon = icon
    }
    
}


extension OnboardingMainViewController: OnboardingBudgetTableViewCellDelegate {
    
    func didAssignMoney(money: Money, to category: String) {
        for selectable in categories {
            if selectable.name == category {
                selectable.assignedMoney = money
            }
        }
        reloadHeader()
    }
    
    func reloadHeader() {
        guard let accounts = accountTableViewController?.accounts else {
            return
        }
        let availableMoney: Money = accounts.reduce(0) { (result, account) -> Money in
            return result + account.money
        }
        let budgetedMoney = categories.reduce(0) { (result, selectable) -> Money in
            return result + selectable.assignedMoney
        }
        let difference = availableMoney - budgetedMoney
        
        if difference < 0 {
            budgetTitleLabel.textColor = .expenseColor
            budgetTitleLabel.text = "You have overbudgeted by \(difference.negative)"
        } else if difference == 0 {
            budgetTitleLabel.textColor = currentProgressColor()
            budgetTitleLabel.text = "You have a perfect budget"
        } else {
            budgetTitleLabel.textColor = currentProgressColor()
            budgetTitleLabel.text = "You have \(difference) left to budget"
        }
    }
    
}

// MARK: - Manage UICollectionView
extension OnboardingMainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1+categories.count // Add element at the beginning. then the categories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCategoryCollectionViewCellID", for: indexPath) as! AddCategoryCollectionViewCell
            cell.outlineColor = currentProgressColor()
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCategoryCellID", for: indexPath) as! CategoryCollectionViewCell
        let item = categories[indexPath.row-1] // Shift index, cause we have add cell at beginnign
        
        cell.selectionColor = currentProgressColor()
        cell.markEditable(editable: item.editable)
        cell.markSelected(selected: cell.isSelected)
        cell.label.text = item.name
        cell.imageView.image = item.icon.withRenderingMode(.alwaysTemplate)
        
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
            categories[indexPath.row - 1].selected = true
            cell.markSelected(selected: true)
        }
        updateContinueButtonState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            categories[indexPath.row - 1].selected = false
            cell.markSelected(selected: false)
        }
        updateContinueButtonState()
    }
    
    func animateContinueButton(visible: Bool) {
        if visible == false {
            UIView.animate(withDuration: 0.2) {
                self.continueButton.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.continueButton.alpha = 1
            }
        }
    }
    
    func updateContinueButtonState() {
        guard let accounts = accountTableViewController?.accounts else {
            return
        }
        if animationInProgress {
            self.continueButton.isEnabled = false
            return
        } else {
            self.continueButton.isEnabled = true
        }
        
        if self.state == .categories {
            let selectedACategory = selectedCategories().count > 0
            continueButton.isEnabled = selectedACategory
            animateContinueButton(visible: selectedACategory)
        } else if state == .accounts {
            let addedAccount = accounts.count > 0
            continueButton.isEnabled = addedAccount
            animateContinueButton(visible: addedAccount)
        }
    }

}

// MARK: - UITextFieldDelegate
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

// MARK: - OnboardingAccountObserver
extension OnboardingMainViewController: OnboardingAccountObserver {
    
    func accountsChanged() {
        updateContinueButtonState()
    }
    
}
