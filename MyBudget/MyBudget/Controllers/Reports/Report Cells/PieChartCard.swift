//
//  PieChartCard.swift
//  MyBudget
//
//  Created by Johannes on 28.10.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class PieChartCard: UIView {

 
    @IBOutlet weak var chartContainer: UIView!
 
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PieChartCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .secondarySystemBackground
        } else {
            contentView.backgroundColor = UIColor.lightGray
        }
        
        layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
       // layer.masksToBounds = true // The rounded corner a valid for the whole card. Nothing can reach over it.
        
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize.init(width: 2, height: 5)
        layer.shadowOpacity = 0.7


    }
    
}
