//
//  Constants.swift
//  MyBudget
//
//  Created by Johannes on 05.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import Foundation

/**
 These Constants are currently only used to distinguish between running the app or running the UITest.
 Communication is done by setting launch arguments and quiring them through ProcessInfo.processInfo.arguments
 */
class Constants {
    
    static var shouldAlwaysShowOnboarding: Bool {
        get {
            if ProcessInfo.processInfo.arguments.contains("shouldAlwaysShowOnboarding") {
                return true
            } else {
                return false
            }
        }
    }
    
    static var shouldUseTouchID: Bool {
        get {
            if ProcessInfo.processInfo.arguments.contains("noTouchID") {
                return false
            } else {
                return true
            }
        }
    }
    
}
