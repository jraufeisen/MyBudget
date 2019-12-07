//
//  CategoryCollectionViewCell.swift
//  MyBudget
//
//  Created by Johannes on 13.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectionColor: UIColor? = UIColor.blueActionColor
    
    override func awakeFromNib() {
        if #available(iOS 13.0, *) {
            backgroundColor = .secondarySystemGroupedBackground
        } else {
            backgroundColor = .white
        }
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.init(width: 1, height: 1)
        layer.masksToBounds = false
        if #available(iOS 13.0, *) {
            label.textColor = .label
            imageView.tintColor = .label
        } else {
            // Fallback on earlier versions
        }

    }
    
    func markEditable(editable: Bool) {
        if editable {
            label.isUserInteractionEnabled = true
        } else {
            label.isUserInteractionEnabled = false
        }
    }
      
    func markSelected(selected: Bool) {
        if selected {
            layer.borderColor = selectionColor?.cgColor
            layer.borderWidth = 2.5
        } else {
            if #available(iOS 13.0, *) {
                layer.borderColor = UIColor.systemFill.cgColor
            } else {
                layer.borderColor = UIColor.lightGray.cgColor
            }
            layer.borderWidth = 0.5
        }
    }
    
}
