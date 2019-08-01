//
//  TextAnimation.swift
//  MyBudget
//
//  Created by Johannes on 01.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation


extension UIKeyInput {
    /// Animates single letters in as if they were written one by one
    func addTextAnimated(text: String, completion: @escaping () -> Void) {
        let timeInBetween = 0.05
        var remainingText = text
        Timer.scheduledTimer(withTimeInterval: timeInBetween, repeats: true) { (timer) in
            if remainingText == "" {
                timer.invalidate()
                completion()
                return
            }
            let c = remainingText.removeFirst()
            self.insertText(String(c))
            //self.text += String(c)
        }
    }

}

