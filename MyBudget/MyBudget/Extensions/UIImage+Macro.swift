//
//  UIImage+Macro.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

extension UIImage {
    
    class func bagImage() -> UIImage {
        return UIImage.init(named: "Bag")!
    }
    
    class func bigBagImage() -> UIImage {
        return UIImage.init(named: "Big Bag")!
    }
    
    class func creditcardsImage() -> UIImage {
        return UIImage.init(named: "Credit Cards")!
    }
    
    class func bigCreditCardImage() -> UIImage {
        return UIImage.init(named: "Big Credit Card")!
    }
    
    class func moneyTrendlineImage() -> UIImage {
        return UIImage.init(named: "Money Trendline")!
    }
    
    class func piggyBankImage() -> UIImage {
        return UIImage.init(named: "Piggy Bank")!
    }
    
    class func securityShieldImage() -> UIImage {
        return UIImage.init(named: "Security Shield")!
    }
    
}

extension UIImage {
    
    func circularIcon(with color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIBezierPath(ovalIn: rect).addClip()
        color.setFill()
        UIRectFill(rect)
        let iconRect = CGRect(x: (rect.size.width - self.size.width) / 2,
                              y: (rect.size.height - self.size.height) / 2,
                              width: self.size.width,
                              height: self.size.height)
        self.draw(in: iconRect, blendMode: .normal, alpha: 1.0)
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    
}
