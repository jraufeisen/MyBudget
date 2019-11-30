//
//  TokenSearchBar.swift
//  MyBudget
//
//  Created by Johannes on 30.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
class TokenSearchBar: UISearchBar {

    var predicateForToken = [UISearchToken: NSPredicate]() // In theory, this can overflow. But wont happen, I'm sure
    
    func addToken(token: UISearchToken, for predicate: NSPredicate) {
        predicateForToken[token] = predicate
        searchTextField.replaceTextualPortion(of: searchTextField.textualRange, with: token, at: 0)
    }

    func completePredicate() -> NSPredicate {
        var predicate: NSPredicate = NSPredicate.init(value: true)
        for token in searchTextField.tokens {
            if let newPredicate = predicateForToken[token] {
                print(newPredicate)
                predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate, newPredicate])
            }
        }
        
        return predicate
        
    }
    
}
