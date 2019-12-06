//
//  NewBudgetCategoryDiaryProvider.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

/// Provides diary information to create a new budget category
class NewBudgetCategoryDiaryProvider: DiaryProvider {
    
    func diaryEntry() -> DiaryEntry {
        return [
            ("Create a new budget category named ", .description),
            (" with an initial balance of ", .money),
        ]
    }
    
}
