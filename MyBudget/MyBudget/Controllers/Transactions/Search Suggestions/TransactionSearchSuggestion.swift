//
//  TransactionSearchSuggestion.swift
//  MyBudget
//
//  Created by Johannes on 07.12.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

// MARK: - TransactionSearchSuggestion
@available(iOS 13.0, *)
class TransactionSearchSuggestion {
    
    var icon: UIImage?
    var text: String
    
    /// Predicate to evaluate with an object of type Transaction
    var predicate: NSPredicate
    
    var searchToken: UISearchToken
    
    init(icon: UIImage?, text: String, predicate: NSPredicate, searchToken: UISearchToken) {
        self.icon = icon
        self.text = text
        self.predicate = predicate
        self.searchToken = searchToken
    }
    
    static func income() -> TransactionSearchSuggestion {
        let icon = #imageLiteral(resourceName: "euro.png").withTintColor(.incomeColor)
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: "Income", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? IncomeTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Income"))
        
        return suggestion
    }
    
    static func expense() -> TransactionSearchSuggestion {
        let icon = #imageLiteral(resourceName: "euro.png").withTintColor(.expenseColor)
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: "Expense", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? ExpenseTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Expense"))
        return suggestion
    }

    static func transfer() -> TransactionSearchSuggestion {
        let icon = #imageLiteral(resourceName: "euro.png").withTintColor(.transferColor)
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: "Transfer", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? TransferTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Transfer"))
        return suggestion
    }
    
    static func thisMonth() -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "This Month", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date.firstDayOfCurrentMonth() == Date().firstDayOfCurrentMonth()
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "This Month"))

        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon

        return suggestion
    }

    static func nameContaining(part: String) -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Name contains \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.description.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Name contains \(part)"))
        
        let icon = UIImage.init(systemName: "magnifyingglass")
        suggestion.icon = icon

        return suggestion
    }
    
    static func dateBefore(date: Date) -> TransactionSearchSuggestion {
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Date before \(localizedDate)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date <= date
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Date before \(localizedDate)"))
        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon
        
        return suggestion
    }

    static func dateAfter(date: Date) -> TransactionSearchSuggestion {
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Date after \(localizedDate)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date >= date
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Date after \(localizedDate)"))
        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon
        return suggestion
    }

    static func accountContains(part: String) -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Account contains \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? IncomeTransaction {
                return tx.account.contains(part)
            } else if let tx = evaluatedObject as? ExpenseTransaction {
                return tx.account.contains(part)
            } else if let tx = evaluatedObject as? TransferTransaction {
                return tx.toAccount.contains(part) || tx.fromAccount.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Account contains \(part)"))
        let icon = UIImage.init(systemName: "magnifyingglass")
        suggestion.icon = icon
        return suggestion
    }
    
    static func tagContains(part: String) -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Tag named \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.tags.contains { (tag) -> Bool in
                    return tag.contains(part)
                }
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Tag named \(part)"))
        let icon = UIImage.init(systemName: "tag")
        suggestion.icon = icon
        return suggestion
    }
    
    static func budgetCategoryContains(part: String) -> TransactionSearchSuggestion {
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: "Budget category named \(part)", predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? ExpenseTransaction {
                return tx.category.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: "Budget category named \(part)"))
        let icon = UIImage.init(systemName: "bag")
        suggestion.icon = icon
        return suggestion
    }
    
}
