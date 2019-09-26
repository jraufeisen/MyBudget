//
//  EditCategoryTableViewCell.swift
//  
//
//  Created by Johannes on 26.09.19.
//

import UIKit

class EditCategoryTableViewCell: UITableViewCell {

    @IBOutlet var textfield: UITextField!
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return textfield.becomeFirstResponder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()


        
        let categoryInput = CategoryTableView.init(outputView: textfield, delegate: self, color: superview?.backgroundColor)
        textfield.inputView = categoryInput
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selectedCategory() -> String? {
        return textfield.text
    }
    
}

extension EditCategoryTableViewCell: CategorySelectDelegate {
    func didSelectCategory(category: String) {
        textfield.text = category
        textfield.resignFirstResponder()

    }
}
