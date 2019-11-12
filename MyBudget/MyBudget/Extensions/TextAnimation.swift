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
    func addTextAnimated(text: String, timeBetweenCharacters: TimeInterval = 0.05, completion: @escaping () -> Void) {
        var remainingText = text
        Timer.scheduledTimer(withTimeInterval: timeBetweenCharacters, repeats: true) { (timer) in
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

extension UILabel {
    func addTextAnimated(text: String, timeBetweenCharacters: TimeInterval = 0.05, completion: (() -> Void)? = nil) {
        var remainingText = text
        Timer.scheduledTimer(withTimeInterval: timeBetweenCharacters, repeats: true) { (timer) in
            if remainingText == "" {
                timer.invalidate()
                completion?()
                return
            }
            let c = remainingText.removeFirst()
            self.text = self.text != nil ? self.text! + String(c) : String(c)
        }

    }
}
