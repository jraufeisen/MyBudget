//
//  PercentFillView.swift
//  MyBudget
//
//  Created by Johannes on 30.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

/// Draws a certain percentage of its bounds using its tintColor.
@IBDesignable class PercentFillView: UIView {


    
    
    ///Between 0 and 1
    @IBInspectable var fillProportion: CGFloat = 0.5 {
        didSet { setNeedsDisplay() }
    }
    
    override func awakeFromNib() {
        backgroundColor = .clear
        layer.borderColor = tintColor?.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect.init(x: 0, y: 0, width: self.frame.width * fillProportion, height: self.frame.height)
        tintColor?.set()
        // UIRectFill(rect)
        
        //Crosshatch
        let path:UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        path.addClip()
        
        let pathBounds = path.bounds
        path.removeAllPoints()
        let p1 = CGPoint(x:pathBounds.maxX, y:0)
        let p2 = CGPoint(x:0, y:pathBounds.maxX)
        path.move(to: p1)
        path.addLine(to: p2)
        path.lineWidth = bounds.width * 2
        
     //   let dashes:[CGFloat] = [0.5, 7.0]
     //   path.setLineDash(dashes, count: 2, phase: 0.0)
        path.stroke()

    }

}
