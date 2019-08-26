//
//  FileManager.swift
//  MyBudget
//
//  Created by Johannes on 16.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

extension FileManager {
    class func documentsURL() -> URL {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return URL.init(fileURLWithPath: paths[0])
    }
    
}
