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

protocol CategorySelectDelegate {
    func didSelectCategory(category: String)
}

protocol CategoryCreationDelegate {
    func createCategory(name: String)
}

class CategoryAccessoryView: UITableView {
    
    var categoryCreationDelegate: CategoryCreationDelegate?
    private var outputView: UIKeyInput?
    
    init(outputView: UIKeyInput?, delegate: CategoryCreationDelegate?, color: UIColor?) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50), style: .plain)

        self.backgroundColor = color
        self.categoryCreationDelegate = delegate
        self.outputView = outputView
        
        self.dataSource = self
        self.isScrollEnabled = false
        register(UINib.init(nibName: "NewCategoryCell", bundle: Bundle.main), forCellReuseIdentifier: "newCategoryCell")
    }
    
    
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}


extension CategoryAccessoryView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newCategoryCell") as? NewCategoryCell else {
            fatalError("new account cell not found")
        }
        
        // All bgColor configuration moves here
        cell.categoryTextField?.backgroundColor = .clear;
        cell.backgroundColor = .clear
        cell.categoryTextField?.textColor = .white
        cell.categoryTextField.delegate = self
        cell.categoryTextField?.font = UIFont.boldSystemFont(ofSize: 18)
        
        return cell
    }
    
}



extension CategoryAccessoryView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let newCategory = textField.text else {
            return true
        }
        if newCategory.isEmpty == false {
            categoryCreationDelegate?.createCategory(name: newCategory)
        }
        return true
    }
}
