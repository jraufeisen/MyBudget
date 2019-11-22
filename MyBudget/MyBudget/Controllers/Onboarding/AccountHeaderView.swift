//
//  AccountHeaderView.swift
//  MyBudget
//
//  Created by Johannes on 14.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class AccountHeaderView: UIView {

    @IBOutlet weak var plusButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blueActionColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        layer.masksToBounds = true
        layer.mask = maskLayer

    }
}
