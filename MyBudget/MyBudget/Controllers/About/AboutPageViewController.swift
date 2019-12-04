//
//  AboutPageViewController.swift
//  MyBudget
//
//  Created by Johannes on 03.12.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import StoreKit
import CloudKit
import BLTNBoard

class AboutPageViewController: UIViewController {

    @IBOutlet weak var subscriptionDetailLabel: UILabel!
    @IBOutlet weak var scubscribeButton: UIButton!
    @IBOutlet weak var largeSubscriptionLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var iCloudIdentifierTextView: UITextView!
    @IBOutlet weak var rateOnAppStoreButton: UIButton!
    
    lazy private var bulletinManager: BLTNItemManager = {
       
        let subscriptionPage = BulletinDataSource.makeSubscriptionPage()
        subscriptionPage.next = BulletinDataSource.makeChoicePage()
        let manager = BLTNItemManager(rootItem: subscriptionPage)
        if #available(iOS 13.0, *) {
            manager.backgroundColor = UIColor.secondarySystemBackground
        }
        return manager
    }()

    
    internal static func instantiate() -> AboutPageViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutPageViewController") as! AboutPageViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set subscription description text manually cause storyboard does not adapt colors for dark mode...
        if #available(iOS 13.0, *) {
            let subscriptionDescription = NSMutableAttributedString()
            
            let boldStart = NSAttributedString.init(string: "Subscribing to Budget ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
            subscriptionDescription.append(boldStart)
            
            let normalBody = NSAttributedString.init(string: "unlocks full access to this app. By downloading Budget!, you have received a contingent of 100 transactions for free. Afterwards, you can still track up to one transaction per day. Subscribing to Budget! removes this limitation and grants full access.", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel])
            subscriptionDescription.append(normalBody)
            


            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            subscriptionDescription.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: subscriptionDescription.length))
            largeSubscriptionLabel.attributedText = subscriptionDescription
        }
        
        // Appearance of rating button
        rateOnAppStoreButton.layer.cornerRadius = 10
        rateOnAppStoreButton.layer.shadowColor = UIColor.init(white: 0, alpha: 1).cgColor
        rateOnAppStoreButton.layer.shadowRadius = 5
        rateOnAppStoreButton.layer.shadowOffset = CGSize.init(width: 2, height: 5)
        rateOnAppStoreButton.layer.shadowOpacity = 0.3

        // Remove text inset from UITextView to fix alignment across view
        iCloudIdentifierTextView.textContainerInset = .zero
        iCloudIdentifierTextView.scrollIndicatorInsets = .zero
        iCloudIdentifierTextView.textContainer.lineFragmentPadding = 0.0
        
        // Rounded rect subscribe button
        scubscribeButton.layer.cornerRadius = 8
        
        // Update subscription status
        let isSubscribed = ServerReceiptValidator().isSubscribed()
        let expirationDate = ServerReceiptValidator().subscriptionExpirationDate()
        if !isSubscribed {
            subscriptionDetailLabel.text = "You are currently not subscribed"
        } else {
            if let expirationDate = expirationDate {
                let formateddate = DateFormatter.localizedString(from: expirationDate, dateStyle: .long, timeStyle: .none)
                subscriptionDetailLabel.text = "Subscribed until \(formateddate)"
            } else {
                subscriptionDetailLabel.text = "You are subscribed"
            }
        }
        
        // Update iCloud identifier text
        CKContainer.init(identifier: "iCloud.com.jraufeisen.MyBudget").fetchUserRecordID { (recordID, error) in
            if let identifier = recordID?.recordName {
                DispatchQueue.main.async {
                    self.iCloudIdentifierTextView.text = identifier
                }
            }
        }
        
        
        // Update version number
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return
        }
        guard let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return
        }
        versionLabel.text = "\(version) (\(build))"
        
        
    }
    
    @IBAction func pressedRateOnAppStore() {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func pressedSubscribe() {
        bulletinManager.showBulletin(above: self)
    }

}
