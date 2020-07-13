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
        let incomeSuggestionText = NSLocalizedString("Income", comment: "")
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: incomeSuggestionText, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? IncomeTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: incomeSuggestionText))
        
        return suggestion
    }
    
    static func expense() -> TransactionSearchSuggestion {
        let icon = #imageLiteral(resourceName: "euro.png").withTintColor(.expenseColor)
        let expenseSuggestionText = NSLocalizedString("Expense", comment: "")
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: expenseSuggestionText, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? ExpenseTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: expenseSuggestionText))
        return suggestion
    }

    static func transfer() -> TransactionSearchSuggestion {
        let icon = #imageLiteral(resourceName: "euro.png").withTintColor(.transferColor)
        let transferSuggestionText = NSLocalizedString("Transfer", comment: "As in: Transferring money from one account to another")
        let suggestion = TransactionSearchSuggestion.init(icon: icon, text: transferSuggestionText, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let _ = evaluatedObject as? TransferTransaction {
                return true
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: transferSuggestionText))
        return suggestion
    }
    
    static func thisMonth() -> TransactionSearchSuggestion {
        let thisMonthSuggestionText = NSLocalizedString("This Month", comment: "Title of a digramm: This month's statistics")
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: thisMonthSuggestionText, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date.firstDayOfCurrentMonth() == Date().firstDayOfCurrentMonth()
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: thisMonthSuggestionText))

        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon

        return suggestion
    }

    static func nameContaining(part: String) -> TransactionSearchSuggestion {
        let nameContainsTextSuggestion = String.init(format: NSLocalizedString("Name contains %@", comment: "%@ stands for an abitrary text"), part)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: nameContainsTextSuggestion, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.description.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: nameContainsTextSuggestion))
        
        let icon = UIImage.init(systemName: "magnifyingglass")
        suggestion.icon = icon

        return suggestion
    }
    
    static func dateBefore(date: Date) -> TransactionSearchSuggestion {
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        let dateBeforeSuggestionText = String.init(format: NSLocalizedString("Date before %@", comment: "%@ stands for a date, which is already localized"), localizedDate)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: dateBeforeSuggestionText, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date <= date
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: dateBeforeSuggestionText))
        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon
        
        return suggestion
    }

    static func dateAfter(date: Date) -> TransactionSearchSuggestion {
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        let dateAfterSuggestionText = String.init(format: NSLocalizedString("Date after %@", comment: "%@ stands for a date, which is already localized"), localizedDate)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: dateAfterSuggestionText, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.date >= date
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: dateAfterSuggestionText))
        let icon = UIImage.init(systemName: "calendar")
        suggestion.icon = icon
        return suggestion
    }

    static func accountContains(part: String) -> TransactionSearchSuggestion {
        let accountContainsTextSuggestion = String.init(format: NSLocalizedString("Account contains %@", comment: "%@ stands for an abitrary text"), part)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: accountContainsTextSuggestion, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? IncomeTransaction {
                return tx.account.contains(part)
            } else if let tx = evaluatedObject as? ExpenseTransaction {
                return tx.account.contains(part)
            } else if let tx = evaluatedObject as? TransferTransaction {
                return tx.toAccount.contains(part) || tx.fromAccount.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: accountContainsTextSuggestion))
        let icon = UIImage.init(systemName: "magnifyingglass")
        suggestion.icon = icon
        return suggestion
    }
    
    static func tagContains(part: String) -> TransactionSearchSuggestion {
        let tagContainsTextSuggestion = String.init(format: NSLocalizedString("Tag named %@", comment: "%@ stands for an abitrary text"), part)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: tagContainsTextSuggestion, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? Transaction {
                return tx.tags.contains { (tag) -> Bool in
                    return tag.contains(part)
                }
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: tagContainsTextSuggestion))
        let icon = UIImage.init(systemName: "tag")
        suggestion.icon = icon
        return suggestion
    }
    
    static func budgetCategoryContains(part: String) -> TransactionSearchSuggestion {
        let budgetCategorySuggestionText = String.init(format: NSLocalizedString("Budget category named %@", comment: "%@ stands for an abitrary text"), part)
        let suggestion = TransactionSearchSuggestion.init(icon: nil, text: budgetCategorySuggestionText, predicate: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            if let tx = evaluatedObject as? ExpenseTransaction {
                return tx.category.contains(part)
            }
            return false
        }), searchToken: UISearchToken.init(icon: nil, text: budgetCategorySuggestionText))
        let icon = UIImage.init(systemName: "bag")
        suggestion.icon = icon
        return suggestion
    }
    
}
