//
//  LockScreenViewController.swift
//  MyBudget
//
//  Created by Johannes on 15.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import LocalAuthentication

class LockScreenViewController: UIViewController {
    /// Instantiate from storyboard
    internal static func instantiate() -> LockScreenViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LockScreenController") as! LockScreenViewController
        return vc
    }

    override func viewDidAppear(_ animated: Bool) {
        authenticateUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedAuthenticationButton(_ sender: Any) {
        authenticateUser()
    }
    
    func authenticateUser() {
        print("Authenticating...")
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentication is needed to access your financial data."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {
            [context .evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: Error?) -> Void in
                
                if success {
                    self.showApplication()
                }  else{
                    print("Bin nicht drin")
                }
                
            })]
        }
        else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            print("Nicht verfügbar")
            showApplication()
        }
    }
    

    func showApplication() {
        DispatchQueue.main.sync {
            let tabbarController = TabbarViewController.instantiate()
            self.view.window?.rootViewController = tabbarController
        }
    }

}
