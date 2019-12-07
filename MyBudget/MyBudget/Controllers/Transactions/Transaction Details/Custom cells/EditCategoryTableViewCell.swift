//
//  EditCategoryTableViewCell.swift
//  
//
//  Created by Johannes on 26.09.19.
//

import UIKit

class EditCategoryTableViewCell: UITableViewCell {

    static let Identifier = "EditCategoryTableViewCell"

    @IBOutlet var textfield: UITextField!
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var symbolBackgroundView: RoundedCornerView!
    
    var colorStyle: EditTransactionDetailsCellStyles = .gray {
        didSet {
            symbolImageView.tintColor = colorStyle.primaryColor()
            symbolBackgroundView.backgroundColor = colorStyle.secondaryColor()
        }
    }
    
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
        if #available(iOS 13.0, *) {
            symbolImageView.image = UIImage.init(systemName: "bag") // SF symbols only available since iOS 13
        } else {
            symbolImageView.image = nil
        }
    }
    
    func selectedCategory() -> String? {
        return textfield.text
    }
    
}

// MARK: - CategorySelectDelegate
extension EditCategoryTableViewCell: CategorySelectDelegate {
    
    func didSelectCategory(category: String) {
        textfield.text = category
        textfield.resignFirstResponder()

    }
}
