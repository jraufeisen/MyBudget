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

    @IBInspectable var progressColor: UIColor = UIColor.systemBlue {
        didSet {
            setUpView()
            setNeedsDisplay()
        }
    }
    
    ///Between 0 and 1
    @IBInspectable var fillProportion: CGFloat = 0.5 {
        didSet {
            setUpView()
            setNeedsDisplay()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    private func setUpView() {
        backgroundColor = .clear
        layer.borderColor = progressColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect.init(x: 0, y: 0, width: self.frame.width * fillProportion, height: self.frame.height)
        progressColor.set()
        let path:UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        path.addClip()
        let pathBounds = path.bounds
        path.removeAllPoints()
        let p1 = CGPoint(x:pathBounds.maxX, y:0)
        let p2 = CGPoint(x:0, y:pathBounds.maxX)
        path.move(to: p1)
        path.addLine(to: p2)
        path.lineWidth = bounds.width * 2
        path.stroke()
    }

}
