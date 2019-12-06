//
//  NewAccount.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

/// Provides diary information to create a new account
class NewAccountDiaryProvider: DiaryProvider {
    
    func diaryEntry() -> DiaryEntry {
        return [
            ("Create a new account named ", .description),
            (" with an initial balance of ", .money),
        ]
    }
    
}
