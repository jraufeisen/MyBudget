//
//  IncomeStatementPercentView.swift
//  MyBudget
//
//  Created by Johannes on 04.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable class IncomeStatementPercentView: UIView {
    
    private var overlayLabel : UILabel!
    
    
    ///Between 0 and 1
    @IBInspectable var fillProportion: CGFloat = 0.5 {
        didSet {
            setUpView()
            setNeedsDisplay()
        }
    }

    
    //Cant be set, will be set depending on isIncome
    override var tintColor: UIColor! {
        get {
            if isIncome {
                return UIColor.incomeColor
            } else {
                return UIColor.expenseColor
            }
        }
        
        set {}
    }
    
    @IBInspectable var isIncome: Bool = true {
        didSet {
            setUpView()
        }
    }
    
    
    @IBInspectable var overlayText: String = "Overlay Text" {
        didSet {
            setUpView()
        }
    }
    
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    
    private func setUpView() {

        backgroundColor = .clear
        layer.borderWidth = 0

        
        if overlayLabel == nil{
            overlayLabel = UILabel.init(frame: CGRect.init(x: 8, y: 0, width: frame.width, height: frame.height))
            overlayLabel.isUserInteractionEnabled = false
            overlayLabel.adjustsFontSizeToFitWidth = true
            overlayLabel.minimumScaleFactor = 0.5
            self.addSubview(overlayLabel)
        }

        overlayLabel.text = overlayText
        overlayLabel.textColor = .white
        
        overlayLabel.sizeToFit()
    }
    
    
    override func draw(_ rect: CGRect) {
        // Draw at least as wide as the label goes.
        // Exception: If the value to display is exactly 0, dont show anything at all
        var drawWidth = max(self.frame.width * fillProportion, overlayLabel.frame.maxX + 8)
        if fillProportion == 0 {
            drawWidth = 0
        }
        
        let rect = CGRect.init(x: 0, y: 0, width: drawWidth, height: self.frame.height)
        tintColor?.set()
        
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
