//
//  NewBudgetCategoryViewController.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class NewBudgetCategoryViewController: UIViewController {
    
    /// Entered by the diary textview
    private var categoryName: String?
    private var initialBalance: Money?
    
    
    
    private var _diaryTextView: DiaryTextView? = nil
    var diaryTextView: DiaryTextView {
        get {
            if let dtv = _diaryTextView {return dtv}
            
            let dtv = DiaryTextView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width - 40, height: view.bounds.height))
            dtv.center = view.center
            dtv.backgroundColor = .clear
            dtv.font = UIFont.systemFont(ofSize: 31)
            dtv.textColor = .white
            dtv.configure(diaryProvider: NewBudgetCategoryDiaryProvider())
            _diaryTextView = dtv
            view.addSubview(dtv)
            
            return dtv
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtonItems()
        
        view.backgroundColor = .incomeColor
        
        diaryTextView.diaryDelegate = self
        diaryTextView.becomeFirstResponder()
    }
    
    
    /// Adds items to the top bar which is useful when presenting the vc modally
    private func addBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: self, action: #selector(self.pressedCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    @objc func pressedCancelButton() {
        _ = diaryTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension NewBudgetCategoryViewController: DiaryDelegate {
    
    private func addFloatingFinishButton() {
        let floaty = Floaty()
        floaty.buttonColor = .white
        floaty.plusColor = .incomeColor // Assign tint color to imageview
        floaty.itemSize = 50
        floaty.handleFirstItemDirectly = true
        floaty.buttonImage = UIImage.init(named: "verify-sign")?.withRenderingMode(.alwaysTemplate)
        
        let item = FloatyItem()
        item.tintColor = .white
        item.buttonColor = .blue
        item.size = floaty.itemSize
        item.handler = { (item) in
            if let accountName = self.categoryName, let balance = self.initialBalance {
                print("I will now add new category \(self.categoryName) with balance \(self.initialBalance)")
                Model.shared.addBudgetCategory(name: accountName, balance: balance)

            }
            self.dismiss(animated: true, completion: nil)
        }
        floaty.addItem(item: item)
        
        view.addSubview(floaty)
    }
    
    
    
    func didFinishDiaryEntry() {
        addFloatingFinishButton()
    }
    
    func didEnterDiaryPair(index: Int, value: Any) {
        if let name = value as? String {
            categoryName = name
            return
        }
        
        if let balance = value as? Money {
            initialBalance = balance
            return
        }
    }
    
    
}
