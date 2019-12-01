//
//  SearchSuggestionTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 30.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class SearchSuggestionTableViewCell: UITableViewCell {

    static let Identifier = "SearchSuggestionTableViewCell"

    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
