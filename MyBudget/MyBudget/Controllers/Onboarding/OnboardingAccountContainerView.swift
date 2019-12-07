//
//  OnboardingAccountContainerView.swift
//  MyBudget
//
//  Created by Johannes on 22.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

// MARK: - OnboardingAccountContainerView
class OnboardingAccountContainerView: UIView {

    /// Add rounded corners at the bottom as well as shadows to the tableview's **container**
    /// Thats the only reason, we definitly need a container here.
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize.init(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.masksToBounds = true
        layer.mask = maskLayer
    }

}
