//
//  SubscriptionSelectorBulletin.swift
//  MyBudget
//
//  Created by Johannes on 30.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation
import BLTNBoard
import CloudKit
import SwiftyStoreKit



class SubscriptionSelectorBulletin: FeedbackPageBLTNItem {

    private var catButtonContainer: UIButton!
    private var dogButtonContainer: UIButton!
    private var selectionFeedbackGenerator = SelectionFeedbackGenerator()
    
    private var currentSelection: SubscriptionDurations? = .FullVersion
    
    // MARK: - BLTNItem
    
    /**
     * Called by the manager when the item is about to be removed from the bulletin.
     *
     * Use this function as an opportunity to do any clean up or remove tap gesture recognizers /
     * button targets from your views to avoid retain cycles.
     */
    
    override func tearDown() {
        catButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        dogButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        catButtonContainer = nil
        dogButtonContainer = nil
    }
    
    /**
     * Called by the manager to build the view hierachy of the bulletin.
     *
     * We need to return the view in the order we want them displayed. You should use a
     * `BulletinInterfaceFactory` to generate standard views, such as title labels and buttons.
     */
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        
        guard catButtonContainer == nil else {return nil} // Workaround to remain interactable after activity activator has been hidden
        
        // We add choice cells to a group stack because they need less spacing
        let petsStack = interfaceBuilder.makeGroupStack(spacing: 16)
        

        let catButtonContainer = createChoiceCell(dataSource: .FullVersion, isSelected: true)
        catButtonContainer.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        petsStack.addArrangedSubview(catButtonContainer)
        
        self.catButtonContainer = catButtonContainer
        
        return [petsStack]
        
    }
    
    // MARK: - Custom Views
    
    func createChoiceCell(dataSource: SubscriptionDurations, isSelected: Bool) -> UIButton {
        
        let button = UIButton(type: .system)
        
        switch dataSource {
        case .FullVersion:
            button.accessibilityLabel = NSLocalizedString("Full Version - 4,49€", comment: "")
            button.setTitle(NSLocalizedString("Full Version - 4,49€", comment: ""), for: .normal)
        }
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.contentHorizontalAlignment = .center
        
        if isSelected {
            button.accessibilityTraits.insert(.selected)
        } else {
            button.accessibilityTraits.remove(.selected)
        }
        
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        let buttonColor = isSelected ? appearance.actionButtonColor : .lightGray
        button.layer.borderColor = buttonColor.cgColor
        button.setTitleColor(buttonColor, for: .normal)
        button.layer.borderColor = buttonColor.cgColor
        
        
        return button
        
    }
    
    // MARK: - Touch Events
    
    /// Called when the cat button is tapped.
    @objc func monthButtonTapped() {
        
        // Play haptic feedback
        
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
        
        // Update UI
        let catButtonColor = appearance.actionButtonColor
        catButtonContainer?.layer.borderColor = catButtonColor.cgColor
        catButtonContainer?.setTitleColor(catButtonColor, for: .normal)
        catButtonContainer?.accessibilityTraits.insert(.selected)
        
        let dogButtonColor = UIColor.lightGray
        dogButtonContainer?.layer.borderColor = dogButtonColor.cgColor
        dogButtonContainer?.setTitleColor(dogButtonColor, for: .normal)
        dogButtonContainer?.accessibilityTraits.remove(.selected)
        
        
    }
    
    /// Called when the dog button is tapped.
    @objc func yearButtonTapped() {
        
        // Play haptic feedback
        
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
        
        // Update UI
        
        let catButtonColor = UIColor.lightGray
        catButtonContainer?.layer.borderColor = catButtonColor.cgColor
        catButtonContainer?.setTitleColor(catButtonColor, for: .normal)
        catButtonContainer?.accessibilityTraits.remove(.selected)
        
        let dogButtonColor = appearance.actionButtonColor
        dogButtonContainer?.layer.borderColor = dogButtonColor.cgColor
        dogButtonContainer?.setTitleColor(dogButtonColor, for: .normal)
        dogButtonContainer?.accessibilityTraits.insert(.selected)
        

    }
    
    override func actionButtonTapped(sender: UIButton) {
        
        // Play haptic feedback
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
        
        manager?.displayActivityIndicator()
        if let selected = currentSelection  {
            var productId = ""
            
            switch selected {
                
            case .FullVersion:
                productId = "com.jraufeisen.MyBudget.Budget_Premium"
            }
            
            CKContainer.default().fetchUserRecordID { (recordID, error) in
                var userName = ""
                print("I found iCloud user with ID \(String(describing: recordID))")
                if let cloudID = recordID?.recordName  {userName = cloudID}
                SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: false, applicationUsername: userName, simulatesAskToBuyInSandbox: false, completion: { (result : PurchaseResult) in
                    DispatchQueue.main.async {
                        self.manager?.hideActivityIndicator()
                        
                        switch result {
                        case .success(let purchase):
                            ServerReceiptValidator().updateExpirationDate()
                            if purchase.needsFinishTransaction {
                                SwiftyStoreKit.finishTransaction(purchase.transaction)
                            }

                            self.next = BulletinDataSource.makeCompletionPage()
                            self.manager?.displayNextItem()
                        case .error(let error):
                            print("There was an error processing this purchase: \(error)")
                            break
                        }
                        
                    }
                    print(result)
                })
            }
        } else {
            manager?.dismissBulletin(animated: true)
        }
        
        
    }
    
}
