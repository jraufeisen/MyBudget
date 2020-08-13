//
//  ReceiptValidator.swift
//  MyBudget_MacOS
//
//  Created by Johannes on 29.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import CloudKit

extension Dictionary {
    
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
    
}

extension CharacterSet {
    
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
    
}

class ServerReceiptValidator: ReceiptValidator {
    
    static let subscriptionStatusDidChangeMessage = Notification.Name.init("subscriptionStatusDidChange")
    
    func restorePurchasesAndReloadSubscriptionState(completion: (() -> ())?) {
        SwiftyStoreKit.restorePurchases { (results: RestoreResults) in
            for purchase in results.restoredPurchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }

                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
            self.updateExpirationDate()
            completion?()
        }
    }
    
    private let fullVersionKey = "fullVersion"
    func updateExpirationDate() {
        SwiftyStoreKit.verifyReceipt(using: ServerReceiptValidator()) { (result) in
            print("Verifying receipt: \(result)")
            switch result {
            case .success:
                KeychainWrapper.standard.set(true, forKey: self.fullVersionKey)
            case .error:
                KeychainWrapper.standard.set(false, forKey: self.fullVersionKey)
                break
            }
            NotificationCenter.default.post(name: ServerReceiptValidator.subscriptionStatusDidChangeMessage, object: nil)
        }
    }
        
    func isFullVersion() -> Bool {
        return KeychainWrapper.standard.bool(forKey: fullVersionKey) == true
    }
    
    func validate(receiptData: Data, completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let receiptString = receiptData.base64EncodedString()
        let url = URL(string: "https://mybudget.app/verify2.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var parameters: [String: Any] = [
            "receipt": receiptString,
        ]
        #if DEBUG
        parameters["DEBUG"] = true
        #endif

        CKContainer.init(identifier: "iCloud.com.jraufeisen.MyBudget").fetchUserRecordID { (recordID, error) in
            if let userName = recordID?.recordName {
                parameters["uid"] = userName
            }
            request.httpBody = parameters.percentEscaped().data(using: .utf8)
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // there is an error
                if let networkError = error {
                    completion(.error(error: .networkError(error: networkError)))
                    return
                }
                
                // there is no data
                guard let safeData = data else {
                    completion(.error(error: .noRemoteData))
                    return
                }
                
                guard let responseString = String.init(data: safeData, encoding: .utf8) else {
                    completion(.error(error: .noRemoteData))
                    return
                }

                if responseString == "True" {
                    let info = ReceiptInfo()
                    completion(.success(receipt: info))
                } else {
                    completion(.error(error: .receiptInvalid(receipt: ReceiptInfo(), status: .unknown)))
                }
            }
            
            task.resume()
        }
    }
    
}


