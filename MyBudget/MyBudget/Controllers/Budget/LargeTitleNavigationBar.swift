//
//  LargeTitleNavigationBar.swift
//  NewLargeTitleSample
//
//  Created by Johannes on 06.10.19.
//  Copyright © 2019 Takuya Aso. All rights reserved.
//

import UIKit

class LargeTitleNavigationBar: UINavigationBar {
    
    private var originalTitleLabel: UILabel?
    func fetchOriginalLabel() -> UILabel? {
        for subview in self.subviews {
            if subview.frame.origin.y > 0 { // This will be the NavigationBarLargeTitleView
                
                let largeSubViews = subview.subviews
                for sbv in largeSubViews {
                    if let lbl = sbv as? UILabel {
                        return lbl
                    }
                }
            }
        }
        
        return nil
    }
    
 
    
    lazy var titleLabel: UILabel = {
        let labelSubtitle = UILabel()
        labelSubtitle.text = ""
        labelSubtitle.numberOfLines = 0

        labelSubtitle.backgroundColor = UIColor.clear
        labelSubtitle.textColor = UIColor.black
        labelSubtitle.font = UIFont.preferredFont(forTextStyle: .largeTitle)

        labelSubtitle.lineBreakMode = .byWordWrapping
        return labelSubtitle
    }()

    
    
    override func layoutSubviews() {

        super.layoutSubviews()

        if let lbl = fetchOriginalLabel() {
            originalTitleLabel = lbl
            /*lbl.layer.borderColor = UIColor.red.cgColor
            lbl.layer.borderWidth = 1*/
        }
        
    }


    func setUpForHeight(height: CGFloat) {
        guard let originalTitleLabel = originalTitleLabel else {
            print("original nicht da")
            return
        }
        guard let embeddingView = originalTitleLabel.superview else {
            print("superview nicht da")
            return
        }
        
        var existingPreferences = [NSAttributedString.Key: Any]()
        if let dict = largeTitleTextAttributes {
            existingPreferences = dict
        }
        
        existingPreferences[.font] = UIFont.systemFont(ofSize: height)
        largeTitleTextAttributes = existingPreferences
        
        
        originalTitleLabel.isHidden = true
        setNeedsDisplay()
        
        if titleLabel.superview == nil {

            embeddingView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            originalTitleLabel.backgroundColor = .red
            NSLayoutConstraint.activate([
                titleLabel.leftAnchor.constraint(equalTo: embeddingView.safeAreaLayoutGuide.leftAnchor, constant: 20),
                titleLabel.rightAnchor.constraint(equalTo: embeddingView.safeAreaLayoutGuide.rightAnchor, constant: -20),
                titleLabel.bottomAnchor.constraint(equalTo: embeddingView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
               // titleLabel.heightAnchor.constraint(equalToConstant: height),
                //   titleLabel.centerXAnchor.constraint(equalTo: embeddingView.centerXAnchor),
             //   titleLabel.centerYAnchor.constraint(equalTo: embeddingView.safeAreaLayoutGuide.centerYAnchor),
            ])
            
            
            print("Layout ambiguous: \(originalTitleLabel.hasAmbiguousLayout)")
            setNeedsDisplay()
        }
        
     //   frame.size.height = 135

        for constraint in constraints {
           // print(constraint.firstAnchor)
            if constraint.firstAnchor == heightAnchor {
             //   removeConstraint(constraint)
            }
        }
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, constant: 44)
        ])
        setNeedsDisplay()
       // print(constraints)
    }
    
    
    
}
