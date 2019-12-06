//
//  UITextView+Center.swift
//  MyBudget
//
//  Created by Johannes on 28.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(0, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

