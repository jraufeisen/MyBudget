//
//  AddCategoryCollectionViewCell.swift
//  MyBudget
//
//  Created by Johannes on 14.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class AddCategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = UIColor.blueActionColor.cgColor
        layer.borderWidth = 2.5
    }
    
}
