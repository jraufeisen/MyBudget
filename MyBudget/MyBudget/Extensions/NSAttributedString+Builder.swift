//
//  NSAttributedString+Builder.swift
//  MyBudget
//
//  Created by Johannes on 04.12.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    func addBoldTitle(title: String) {
        var attributes: [NSAttributedString.Key:Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        if #available(iOS 13.0, *) {
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.label
        }
        
        let boldHeading = NSAttributedString.init(string: title, attributes: attributes)
        append(boldHeading)
    }
    
    func addBody(title: String) {
        var attributes: [NSAttributedString.Key:Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        if #available(iOS 13.0, *) {
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.secondaryLabel
        }
        
        let body = NSAttributedString.init(string: title, attributes: attributes)
        append(body)
    }
    
}

extension NSAttributedString {
    
    /// Builds an attributed string like on a product page in the App Store
    static func appStoreLikeDescription(title: String, body: String) -> NSAttributedString {
        let string = NSMutableAttributedString.init(string: "", attributes: nil)
        string.addBoldTitle(title: title)
        string.addBody(title: body)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        string.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: string.length))

        
        return string
    }
}
