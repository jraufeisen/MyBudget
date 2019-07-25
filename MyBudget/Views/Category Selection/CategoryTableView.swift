//
//  AccountTableView.swift
//  MyBudget
//
//  Created by Johannes on 24.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit



class NewCategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTextField: UITextField!
}

class ExistingCategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
}

protocol CategorySelectDelegate {
    func didSelectCategory(category: String)
}

class CategoryTableView: UITableView {
    let categories = ["Rent", "Groceries", "Fun money"]
    
    var categoryDelegate: CategorySelectDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self
        
        register(UINib.init(nibName: "NewCategoryCell", bundle: Bundle.main), forCellReuseIdentifier: "newCategoryCell")
        register(UINib.init(nibName: "ExistingCategoryCell", bundle: Bundle.main), forCellReuseIdentifier: "existingCategoryCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


extension CategoryTableView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newCategoryCell") as? NewCategoryCell else {
                fatalError("new account cell not found")
            }
            // All bgColor configuration moves here
            cell.categoryTextField?.backgroundColor = .clear;
            cell.backgroundColor = .clear
            cell.categoryTextField?.textColor = .white
            
            cell.categoryTextField?.text = "New account"
            cell.categoryTextField?.font = UIFont.boldSystemFont(ofSize: 18)
            return cell
        }
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "existingCategoryCell") as? ExistingCategoryCell else {
            fatalError("existing account cell not found")
        }
        
        
        // All bgColor configuration moves here
        cell.categoryLabel?.backgroundColor = .clear;
        cell.backgroundColor = .clear
        cell.categoryLabel?.textColor = .white
        cell.categoryLabel?.text = categories[indexPath.row-1]
        
        
        return cell
    }
    

    
}

extension CategoryTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let selectedCategory = categories[indexPath.row-1]
        categoryDelegate?.didSelectCategory(category: selectedCategory)
    }
}
