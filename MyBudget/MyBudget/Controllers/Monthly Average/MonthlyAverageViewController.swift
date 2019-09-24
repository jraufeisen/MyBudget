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
    
    private let viewables = Model.shared.getLastMonthSpending()
    
    
    internal static func instantiate() -> MonthlyAverageViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "monthlyAverageVC") as! MonthlyAverageViewController
        return vc
    }

    override func viewDidLoad() {


        
        
        if viewables.isEmpty {
            addHelpingLabels()
        } else {
            removeHelpingLabels()
        }
    }
    
    let titleHelpingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 50))
    let descriptionHelpingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 50))
    private func addHelpingLabels() {
        titleHelpingLabel.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width - 60, height: 50)
        titleHelpingLabel.textAlignment = .center
        titleHelpingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleHelpingLabel.center = view.center
        titleHelpingLabel.text = "Track your expenses!"
        titleHelpingLabel.sizeToFit()
        titleHelpingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleHelpingLabel)
        var centerX = NSLayoutConstraint.init(item: titleHelpingLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        var centerY = NSLayoutConstraint.init(item: titleHelpingLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -20)
        view.addConstraints([centerX, centerY])

        
        descriptionHelpingLabel.frame = CGRect.init(x: 0, y: titleHelpingLabel.center.y + 15, width: view.bounds.width - 60, height: 150)
        descriptionHelpingLabel.textAlignment = .center
        descriptionHelpingLabel.numberOfLines = 10
        descriptionHelpingLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionHelpingLabel.textColor = .lightGray
        descriptionHelpingLabel.center = CGPoint.init(x: titleHelpingLabel.center.x, y: descriptionHelpingLabel.center.y)
        descriptionHelpingLabel.text = "You have not tracked your expenses during the last month, so there is nothing to see here. Click on the plus button at the bottom and start tracking."
        descriptionHelpingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionHelpingLabel)
        let width = NSLayoutConstraint.init(item: descriptionHelpingLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: -60)
        let height = NSLayoutConstraint.init(item: descriptionHelpingLabel, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0, constant: 100)
        centerX = NSLayoutConstraint.init(item: descriptionHelpingLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        centerY = NSLayoutConstraint.init(item: descriptionHelpingLabel, attribute: .top, relatedBy: .equal, toItem: titleHelpingLabel, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([width, height, centerX, centerY])
    }
    
    
    private func removeHelpingLabels() {
        titleHelpingLabel.removeFromSuperview()
        descriptionHelpingLabel.removeFromSuperview()
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
