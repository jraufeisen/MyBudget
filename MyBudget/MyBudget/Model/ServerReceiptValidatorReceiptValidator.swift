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
    
    
    
    func validate(receiptData: Data, completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let receiptString = receiptData.base64EncodedString()
        let url = URL(string: "https://mybudget.app/verify.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var parameters: [String: Any] = [
            "receipt": receiptString,
        ]
        
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
                print(responseString)
                
                if responseString == "True" {
                    completion(.success(receipt: ReceiptInfo()))

                } else {
                    completion(.error(error: .receiptInvalid(receipt: ReceiptInfo(), status: .subscriptionExpired)))
                }
            }
        
            task.resume()
        }
    }
    
    

}


