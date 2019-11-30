//
//  TokenSearchController.swift
//  MyBudget
//
//  Created by Johannes on 30.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
class TokenSearchController: UISearchController {

    
    // Mark this property as lazy to defer initialization until
    // the searchBar property is called.
    private lazy var customSearchBar = TokenSearchBar()

    // Override this property to return your custom implementation.
    override var searchBar: TokenSearchBar { customSearchBar }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
