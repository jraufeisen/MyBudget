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

        let page = SubscriptionSelectorBulletin(title: "Subscriptions")
        page.isDismissable = true
        page.descriptionText = "All subscriptions sync across your iCloud devices"
        page.actionButtonTitle = "Purchase"

        
        return page

    }

   
    static func makeSubscriptionPage() -> BLTNPageItem {
        let subscriptionPage = BLTNPageItem(title: "Subscribe")
        subscriptionPage.image = #imageLiteral(resourceName: "Logo_Only")
        subscriptionPage.appearance.imageViewTintColor = .blueActionColor
        subscriptionPage.descriptionText = "Unlock unlimited access by subscribing either monthly or annualy."
        subscriptionPage.actionButtonTitle = "Learn More"
        subscriptionPage.actionHandler = { (item: BLTNActionItem) in
            let choice = makeChoicePage()
            subscriptionPage.next = choice
            item.manager?.displayNextItem()
        }
        subscriptionPage.alternativeButtonTitle = "Restore Purchases"
        subscriptionPage.alternativeHandler = { (item: BLTNActionItem) in

            item.manager?.displayActivityIndicator()
            ServerReceiptValidator().restorePurchasesAndReloadSubscriptionState() {
                let completion = makeRestoreCompletedPage()
                subscriptionPage.next = completion
                item.manager?.displayNextItem()
                item.manager?.hideActivityIndicator()

            }
        }
        
        return subscriptionPage
    }
    
    static func makeRestoreCompletedPage() -> BLTNPageItem {
        let completion = makeCompletionPage()
        completion.descriptionText = "Your purchases have been restored"
        return completion
    }
    
    static func makeCompletionPage() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Success")
        page.image = #imageLiteral(resourceName: "IntroCompletion")
        page.imageAccessibilityLabel = "Checkmark"
        page.appearance.actionButtonColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.appearance.imageViewTintColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.appearance.actionButtonTitleColor = .white
        
        page.descriptionText = "You now have unlimited access to Budget!"
        page.actionButtonTitle = "Get started"
        
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
        
        return page
        
    }

    
}
