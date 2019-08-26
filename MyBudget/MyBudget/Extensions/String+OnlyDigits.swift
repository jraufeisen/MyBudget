//
//  String+OnlyDigits.swift
//  MyBudget
//
//  Created by Johannes on 27.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

extension String {

    func onlyDigits() -> String {
        let digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        var digitString = ""
        for c in self {
            if digits.contains(String(c)) {
                digitString += String(c)
            }
        }
        return digitString
    }
    
}
