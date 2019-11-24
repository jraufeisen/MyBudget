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
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!

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
            contentView.backgroundColor = .secondarySystemGroupedBackground
        } else {
            contentView.backgroundColor = UIColor.lightGray
        }
        
        layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        layer.shadowColor = UIColor.init(white: 0, alpha: 1.0).cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize.init(width: 2, height: 5)
        layer.shadowOpacity = 0.3
    }
    
}
