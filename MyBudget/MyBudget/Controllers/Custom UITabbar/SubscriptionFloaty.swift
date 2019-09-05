//
//  Subscriptionswift
//  MyBudget
//
//  Created by Johannes on 02.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

class SubscriptionFloaty: Floaty {

    let incomeItem = FloatyItem()
    let transferItem = FloatyItem()
    let expenseItem = FloatyItem()
    let subscribeItem = FloatyItem()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateToSubscriptionStatus), name: ServerReceiptValidator.subscriptionStatusDidChangeMessage, object: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func updateToSubscriptionStatus() {
        incomeItem.buttonColor = Model.shared.allowedToAddTransaction() ? .incomeColor : .gray
        transferItem.buttonColor = Model.shared.allowedToAddTransaction() ? .transferColor : .gray
        expenseItem.buttonColor = Model.shared.allowedToAddTransaction() ? .expenseColor : .gray
        if !ServerReceiptValidator().isSubscribed() {
            addItem(item: subscribeItem)
        } else {
            removeItem(item: subscribeItem)
        }

    }
    
    private func setup() {
        self.accessibilityLabel = "Add new transaction"

        
        buttonColor = .white
        plusColor = UITabBar().tintColor //Standard blue tint color
        itemSize = 50
        overlayColor = .clear // Use custom blur instead, so that tabbar stays white

        incomeItem.titleColor = .darkText
        incomeItem.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        incomeItem.title = "Income"
        incomeItem.tintColor = .white
        incomeItem.buttonColor = Model.shared.allowedToAddTransaction() ? .incomeColor : .gray
        incomeItem.size = itemSize
        incomeItem.accessibilityLabel = "New Income"

        addItem(item: incomeItem)
        

        transferItem.titleColor = .darkText
        transferItem.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        transferItem.title = "Transfer"
        transferItem.tintColor = .white
        transferItem.buttonColor = Model.shared.allowedToAddTransaction() ? .transferColor : .gray
        transferItem.size = itemSize
        addItem(item: transferItem)
        transferItem.accessibilityLabel = "New Transfer"


        expenseItem.titleColor = .darkText
        expenseItem.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        expenseItem.title = "Expense"
        expenseItem.tintColor = .white
        expenseItem.buttonColor = Model.shared.allowedToAddTransaction() ? .expenseColor : .gray
        expenseItem.size = itemSize
        expenseItem.accessibilityLabel = "New Expense"

        addItem(item: expenseItem)
        

        
        subscribeItem.titleColor = .darkText
        subscribeItem.icon = #imageLiteral(resourceName: "Logo_Only").withRenderingMode(.alwaysTemplate)
        subscribeItem.title = "Subscribe"
        subscribeItem.tintColor = .white
        subscribeItem.buttonColor = .blueActionColor
        subscribeItem.size = itemSize
        subscribeItem.accessibilityLabel = "Subscribe"
        if !ServerReceiptValidator().isSubscribed() {
            addItem(item: subscribeItem)
        }

        // Dont move - ever. Stay fixed in the tabbar
        respondsToKeyboard = false
    }
    
    
    
}
