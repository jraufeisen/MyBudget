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

    var outlineColor: UIColor? = UIColor.blueActionColor {
        didSet {
            layer.borderColor = outlineColor?.cgColor
            imageView.tintColor = outlineColor
        }
    }
    
    override func awakeFromNib() {
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = outlineColor?.cgColor
        layer.borderWidth = 2.5
        
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
}
