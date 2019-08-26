//
//  AccountTableView.swift
//  MyBudget
//
//  Created by Johannes on 24.07.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit




class ExistingCategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
}


class CategoryTableView: UITableView {
    private var categories = [String]()
    
    var categoryDelegate: CategorySelectDelegate?
    private var outputView: UIKeyInput?

    
    init(outputView: UIKeyInput?, delegate: CategorySelectDelegate?, color: UIColor?) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2), style: .plain)
        self.backgroundColor = color
        self.categoryDelegate = delegate
        self.outputView = outputView
        
        self.dataSource = self
        self.delegate = self
        
        autoresizingMask = .flexibleHeight // When used as inputview, this makes thei height be equal to standard keyboard height
        register(UINib.init(nibName: "ExistingCategoryCell", bundle: Bundle.main), forCellReuseIdentifier: "existingCategoryCell")
        
        for categoryViewable in Model.shared.getAllBudgetCategories() {
            categories.append(categoryViewable.name)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


extension CategoryTableView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "existingCategoryCell") as? ExistingCategoryCell else {
            fatalError("existing account cell not found")
        }
        
        
        // All bgColor configuration moves here
        cell.categoryLabel?.backgroundColor = .clear;
        cell.backgroundColor = .clear
        cell.categoryLabel?.textColor = .white
        cell.categoryLabel?.text = categories[indexPath.row]
        
        
        return cell
    }
    

    
}

extension CategoryTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        outputView?.insertText(selectedCategory)
        categoryDelegate?.didSelectCategory(category: selectedCategory)
    }
}


extension CategoryTableView: CategoryCreationDelegate {
    func createCategory(name: String) {
        categories.insert(name, at: 0)
        reloadSections([0], with: .automatic)
    }
}
