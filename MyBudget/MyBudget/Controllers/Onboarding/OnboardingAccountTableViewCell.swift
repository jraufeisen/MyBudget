//
//  OnboardingAccountTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 14.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class OnboardingAccountTableViewCell: UITableViewCell {

    static let Identifier: String = "OnboardingAccountTableViewCellID"
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
