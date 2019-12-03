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
        
        if #available(iOS 13.0, *) {
            iconImageView.image = UIImage.init(systemName: "magnifyingglass")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
