//
//  Model.swift
//  MyBudget
//
//  Created by Johannes on 23.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Money

struct BudgetCategoryViewable {
    let name: String
    let remainingMoney: Money
    let percentLeft: NSNumber // Between 0 and 100
    let detailString: String
}

class Model: NSObject {

    static let shared = Model()
    private override init() {
        
    }
    
    func getAllBudgetCategories() -> [BudgetCategoryViewable] {
        var categoryViewables = [BudgetCategoryViewable]()
        
        let dummyCategories = ["Groceries", "Rent", "Fun", "Eating out", "Something"]
        for i in 0...4 {
            let viewable = BudgetCategoryViewable.init(name: dummyCategories[i], remainingMoney: Money.init(i*10), percentLeft: NSNumber(value: i*20), detailString: "")
            categoryViewables.append(viewable)
        }
        
        return categoryViewables
    }
    
    
}
