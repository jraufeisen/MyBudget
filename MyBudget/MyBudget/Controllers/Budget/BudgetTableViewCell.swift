//
//  BudgetTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 30.12.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation
import SwipeCellKit

// MARK: - Edit Delegate
protocol BudgetCellEditDelegate {
    func didChangeCategoryName(cell: BudgetTableViewCell, newName: String?)
}

//MARK: - BudgetTableViewCell
class BudgetTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var percentFillView: PercentFillView!
    @IBOutlet weak var detailLabel: UILabel!
    
    var editDelegate: BudgetCellEditDelegate?
    
    override func awakeFromNib() {
        insetView.layer.cornerRadius = 10
        
        if #available(iOS 13.0, *) {
            insetView.backgroundColor = UIColor.secondarySystemGroupedBackground
            detailLabel.textColor = UIColor.label
        }
        
        percentFillView.progressColor = .blueActionColor
        
        selectionStyle = .none

        insetView.layer.cornerRadius = 10
        insetView.layer.shadowColor = UIColor.init(white: 0, alpha: 1.0).cgColor
        insetView.layer.shadowRadius = 5
        insetView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        insetView.layer.shadowOpacity = 0.3
        
        categoryTextField.delegate = self
    }
    
    func beginEditCategoryName() {
        categoryTextField.isUserInteractionEnabled = true
        categoryTextField.becomeFirstResponder()
    }
    
}

// MARK: - UITextFieldDelegate
extension BudgetTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        categoryTextField.isUserInteractionEnabled = false
        editDelegate?.didChangeCategoryName(cell: self, newName: textField.text)
        return true
    }
}
