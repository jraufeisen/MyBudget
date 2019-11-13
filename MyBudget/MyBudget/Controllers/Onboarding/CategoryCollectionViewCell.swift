//
//  CategoryCollectionViewCell.swift
//  MyBudget
//
//  Created by Johannes on 13.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var label: UILabel!

    
    override func awakeFromNib() {


        layer.borderWidth = 1
        
        layer.cornerRadius = 10
        /*layer.shadowColor = UIColor.init(white: 0, alpha: 1).cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize.init(width: 2, height: 5)
        layer.shadowOpacity = 0.3*/
    }
    
  
    var marked: Bool = false
    
    
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
