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
        }
    }

    func addTextAnimated(text: String, animationDuration: TimeInterval = 0.2, completion: @escaping () -> Void) {
        let timeInBetween = animationDuration / Double(text.count)
        addTextAnimated(text: text, timeBetweenCharacters: timeInBetween, completion: completion)
    }

}

extension UILabel {
    
    func addTextAnimated(text: String, timeBetweenCharacters: TimeInterval = 0.05, completion: (() -> Void)? = nil) {
        
        let completeText = self.text! + text
        let formattedString = wordWrapFormattedStringFor(string: completeText)
        var remainingText = formattedString.replacingCharacters(in: ...self.text!.endIndex, with: "")
        if self.text!.count == 0 {
            remainingText = formattedString.replacingCharacters(in: ..<self.text!.endIndex, with: "")
        }
        
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
    
    func addTextAnimated(text: String, animationDuration: TimeInterval = 0.2, completion: @escaping () -> Void) {
        let timeInBetween = animationDuration / Double(text.count)
        addTextAnimated(text: text, timeBetweenCharacters: timeInBetween, completion: completion)
    }

    /// Calculate a detailed string adding whitespaces at the right places where the label would add them anyway due to linebreaking.
    /// This method can be used to make character by character animation smoother
    /// - Parameter string: The **complete** string that should be set as the .text of the label.
    func wordWrapFormattedStringFor(string: String) -> String {
        // Prepare array with indexes of all whitespace characters
        let whitespaceIndexes: [String.Index] = {
            let whitespacesSet = CharacterSet.whitespacesAndNewlines
            var indexes: [String.Index] = []

            string.unicodeScalars.enumerated().forEach { i, unicodeScalar in
                if whitespacesSet.contains(unicodeScalar) {
                    let index = string.index(string.startIndex, offsetBy: i)
                    indexes.append(index)
                }
            }

            // We want also the index after the last character so that when we make substrings later we include also the last word
            // This index can only be used for substring to this index (not from or including, since it points to \0)
            let index = string.index(string.startIndex, offsetBy: string.count)
            indexes.append(index)

            return indexes
        }()
        var reformattedString = ""
        let boundingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 18)]
        var runningHeight: CGFloat?
        var previousIndex: String.Index?
        whitespaceIndexes.forEach { index in
            let string = String(string[..<index])
            let stringHeight = string.boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).height
            var newString: String = {
                if let previousIndex = previousIndex {
                    return String(string[previousIndex...])
                } else {
                    return string
                }
            }()
            if runningHeight == nil {
                runningHeight = stringHeight
            }
            if runningHeight! < stringHeight {
                // Check that we can create a new index with offset of 1 and that newString does not contain only a whitespace (for example if there are multiple consecutive whitespaces)
                if newString.count > 1 {
                    let splitIndex = newString.index(newString.startIndex, offsetBy: 1)
                    // Insert a new line between the whitespace and rest of the string
                    newString.insert("\n", at: splitIndex)
                }
            }
            reformattedString += newString
            runningHeight = stringHeight
            previousIndex = index
        }
        return reformattedString
        
    }

}
