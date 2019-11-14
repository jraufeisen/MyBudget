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
    
    override func awakeFromNib() {
        layer.borderWidth = 1
        layer.cornerRadius = 10
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
            layer.borderColor = UIColor.blueActionColor.cgColor
            layer.borderWidth = 2.5
        } else {
            if #available(iOS 13.0, *) {
                layer.borderColor = UIColor.systemFill.cgColor
            } else {
                layer.borderColor = UIColor.lightGray.cgColor
            }
            layer.borderWidth = 1
        }
    }
}

