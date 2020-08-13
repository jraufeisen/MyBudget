/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard
import SafariServices

/**
 * A set of tools to interact with the demo data.
 *
 * This demonstrates how to create and configure bulletin items.
 */

enum BulletinDataSource {

    // MARK: - Pages
    static func makeChoicePage() -> SubscriptionSelectorBulletin {

        let page = SubscriptionSelectorBulletin(title: NSLocalizedString("Full Version", comment: ""))
        page.isDismissable = true
        page.descriptionText = NSLocalizedString("Your purchase syncs across your iCloud devices", comment: "")
        page.actionButtonTitle = NSLocalizedString("Purchase", comment: "")

        if #available(iOS 13.0, *) {
            page.appearance.titleTextColor = .label
            page.appearance.descriptionTextColor = .label
        }

        return page
    }

    static func makeSubscriptionPage() -> BLTNPageItem {
        let subscriptionPage = BLTNPageItem(title: NSLocalizedString("Full Version", comment: ""))
        subscriptionPage.image = #imageLiteral(resourceName: "Logo_Only")
        subscriptionPage.appearance.imageViewTintColor = .blueActionColor
        subscriptionPage.descriptionText = NSLocalizedString("Unlock unlimited access by purchasing the full version.", comment: "")
        subscriptionPage.actionButtonTitle = NSLocalizedString("Learn More", comment: "")
        subscriptionPage.actionHandler = { (item: BLTNActionItem) in
            let choice = makeChoicePage()
            subscriptionPage.next = choice
            item.manager?.displayNextItem()
        }
        subscriptionPage.alternativeButtonTitle = NSLocalizedString("Restore Purchases", comment: "")
        subscriptionPage.alternativeHandler = { (item: BLTNActionItem) in

            item.manager?.displayActivityIndicator()
            ServerReceiptValidator().restorePurchasesAndReloadSubscriptionState() {
                let completion = makeRestoreCompletedPage()
                subscriptionPage.next = completion
                item.manager?.displayNextItem()
                item.manager?.hideActivityIndicator()

            }
        }
        
        if #available(iOS 13.0, *) {
            subscriptionPage.appearance.titleTextColor = .label
            subscriptionPage.appearance.descriptionTextColor = .label
        }
        return subscriptionPage
    }
    
    static func makeRestoreCompletedPage() -> BLTNPageItem {
        let completion = makeCompletionPage()
        completion.descriptionText = NSLocalizedString("Your purchases have been restored", comment: "")
        return completion
    }
    
    static func makeCompletionPage() -> BLTNPageItem {
        let page = BLTNPageItem(title: NSLocalizedString("Success", comment: ""))

        page.image = #imageLiteral(resourceName: "IntroCompletion")
        page.imageAccessibilityLabel = NSLocalizedString("Checkmark", comment: "")
        page.appearance.actionButtonColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.appearance.imageViewTintColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.appearance.actionButtonTitleColor = .white
        
        page.descriptionText = NSLocalizedString("You now have unlimited access to Budget!", comment: "")
        page.actionButtonTitle = NSLocalizedString("Get started", comment: "")
        
        page.isDismissable = true
        
        page.dismissalHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        page.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        if #available(iOS 13.0, *) {
            page.appearance.titleTextColor = .label
            page.appearance.descriptionTextColor = .label
        }

        return page
    }

}
