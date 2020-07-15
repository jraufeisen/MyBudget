//
//  Subscriptionswift
//  MyBudget
//
//  Created by Johannes on 02.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

// MARK: - SubscriptionFloaty
class SubscriptionFloaty: Floaty {

    let incomeItem = FloatyItem()
    let transferItem = FloatyItem()
    let expenseItem = FloatyItem()

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
    }
    
    private func setup() {
        self.accessibilityLabel = NSLocalizedString("Add new transaction", comment: "")

        buttonColor = .white
        
        if #available(iOS 13.0, *) {
            buttonColor = UIColor.tertiarySystemGroupedBackground
        }
        
        plusColor = UITabBar().tintColor //Standard blue tint color
        itemSize = 50
        overlayColor = .clear // Use custom blur instead, so that tabbar stays white

        incomeItem.titleColor = .darkText
        if #available(iOS 13.0, *) {
            incomeItem.titleColor = UIColor.label
        }
        incomeItem.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        incomeItem.title = NSLocalizedString("Income", comment: "")
        incomeItem.tintColor = .white
        incomeItem.buttonColor = Model.shared.allowedToAddTransaction() ? .incomeColor : .gray
        incomeItem.size = itemSize
        incomeItem.accessibilityLabel = NSLocalizedString("New Income", comment: "As in: new income transactions")

        addItem(item: incomeItem)
        
        transferItem.titleColor = .darkText
        if #available(iOS 13.0, *) {
            transferItem.titleColor = UIColor.label
        }
        transferItem.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        transferItem.title = NSLocalizedString("Transfer", comment: "")
        transferItem.tintColor = .white
        transferItem.buttonColor = Model.shared.allowedToAddTransaction() ? .transferColor : .gray
        transferItem.size = itemSize
        addItem(item: transferItem)
        transferItem.accessibilityLabel = NSLocalizedString("New Transfer", comment: "As in: new transfer transactions")


        expenseItem.titleColor = .darkText
        if #available(iOS 13.0, *) {
            expenseItem.titleColor = UIColor.label
        }
        expenseItem.icon = UIImage.init(named: "euro")?.withRenderingMode(.alwaysTemplate)
        expenseItem.title = NSLocalizedString("Expense", comment: "")
        expenseItem.tintColor = .white
        expenseItem.buttonColor = Model.shared.allowedToAddTransaction() ? .expenseColor : .gray
        expenseItem.size = itemSize
        expenseItem.accessibilityLabel = NSLocalizedString("New Expense", comment: "As in: new expense transactions")

        addItem(item: expenseItem)
        
        // Dont move - ever. Stay fixed in the tabbar
        respondsToKeyboard = false
    }
    
}
