//
//  RoundedCornerView.swift
//  MyBudget
//
//  Created by Johannes on 27.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
   
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       sharedInit()
    }
   
    override func prepareForInterfaceBuilder() {
       sharedInit()
    }
   
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
