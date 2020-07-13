//
//  EditTagsTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 26.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import WSTagsField

class EditTagsTableViewCell: UITableViewCell {

    static let Identifier = "EditTagsTableViewCell"
    
    @IBOutlet weak var tagField: WSTagsField!
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var symbolBackgroundView: RoundedCornerView!
    
    var tags = [String]() {
        didSet {
            loadTagsInTagField()
        }
    }
    
    var colorStyle: EditTransactionDetailsCellStyles = .gray {
        didSet {
            symbolImageView.tintColor = colorStyle.primaryColor()
            symbolBackgroundView.backgroundColor = colorStyle.secondaryColor()
            setupTagField()
        }
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return tagField.becomeFirstResponder()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupTagField()
        if #available(iOS 13.0, *) {
            symbolImageView.image = UIImage.init(systemName: "tag") // SF symbols only available since iOS 13
        } else {
            symbolImageView.image = nil
        }
        
    }

    private func loadTagsInTagField() {
        for tag in tags {
            if !tagField.tags.contains(WSTag.init(tag)) { // Prevent duplicates in tagField.tags (although not reaally necesary)
                tagField.addTags(tags) // Updating the UI here.
            }
        }
    }
    
    private func setupTagField() {
        tagField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagField.spaceBetweenLines = 5.0
        tagField.spaceBetweenTags = 10.0
        tagField.font = .systemFont(ofSize: 12.0)
        tagField.backgroundColor = .white
        tagField.cornerRadius = 6
        tagField.tintColor = EditTransactionDetailsCellStyles.gray.secondaryColor()
        tagField.placeholderColor = EditTransactionDetailsCellStyles.gray.secondaryColor()

        if #available(iOS 13.0, *) {
            tagField.textColor = .label
            tagField.fieldTextColor = .label
            tagField.placeholderColor = .placeholderText
        }
        tagField.selectedColor = colorStyle.secondaryColor()
        tagField.placeholder = NSLocalizedString("Add tags here...", comment: "")
        tagField.placeholderAlwaysVisible = true
        tagField.returnKeyType = .done
        tagField.textDelegate = self
        tagField.acceptTagOption = .return
        
        tagField.onDidAddTag = { (field, tag) in
            if self.tags.firstIndex(of: tag.text) == nil { // Prevent duplicates in sef.tags
                self.tags.append(tag.text)
            }
        }
        
        tagField.onDidRemoveTag = { (field, tag) in
            if let existingIndex = self.tags.firstIndex(of: tag.text) {
                self.tags.remove(at: existingIndex)
            }
        }
        
    }

}

// MARK: - UITextFieldDelegate
extension EditTagsTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
