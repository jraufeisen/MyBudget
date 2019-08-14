//
//  MonthlyAverageViewController.swift
//  MyBudget
//
//  Created by Johannes on 14.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class MonthlyAverageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    private let viewables = Model.shared.getMonthlyAverages()
    
    
    internal static func instantiate() -> MonthlyAverageViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "monthlyAverageVC") as! MonthlyAverageViewController
        return vc
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "monthlyAverageCell") else {
            return UITableViewCell()
        }
        
        let viewable = viewables[indexPath.row]
        cell.textLabel?.text = viewable.name
        cell.detailTextLabel?.text = "\(viewable.averageSpent)"
        
        return cell
        
    }
    
    @IBAction func pressedMenu(_ sender: Any) {
        guard let menuPresentingController = navigationController as? MenuPresentingViewController else {
            fatalError("The presenting navigationcontroller is not a menu presenting view controller")
        }
        
        menuPresentingController.showMenu()
    }


}
