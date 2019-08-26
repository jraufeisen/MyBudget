//
//  MenuViewController.swift
//  MyBudget
//
//  Created by Johannes on 01.08.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import SideMenu

enum MenuItem {
    case Budget
    case Accounts
    case Reports
    case Export
}

/// Protocol to select menus on click
protocol MenuSelectionDelegate {
    func didSelectMenuItem(item: MenuItem)
}



/// Uses tintcolor to paint
class MenuSelectionView: UIView {
    override func draw(_ rect: CGRect) {
        let rect = CGRect.init(x: -20, y: 0, width: self.frame.width - 10, height: self.frame.height)
        tintColor?.set()
        
        //Crosshatch
        let path:UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 20)
        path.addClip()
        
        let pathBounds = path.bounds
        path.removeAllPoints()
        let p1 = CGPoint(x:pathBounds.maxX, y:0)
        let p2 = CGPoint(x:0, y:pathBounds.maxX)
        path.move(to: p1)
        path.addLine(to: p2)
        path.lineWidth = bounds.width * 2
        
        path.stroke()
    }
}

class MenuCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        
        // Adjust selection color
        let bgColorView = MenuSelectionView()
        bgColorView.tintColor = UIColor.blueActionColor.withAlphaComponent(0.6)
        selectedBackgroundView = bgColorView
    }
    
    func markSelected(selected: Bool) {
        //Adjust label color
        if isSelected {
            label.textColor = UIColor.blueActionColor
            setNeedsDisplay()
        } else {
            label.textColor = UIColor.darkText
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isSelected {
            label.textColor = UIColor.blue
            label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
            setNeedsDisplay()
        } else {
            label.textColor = UIColor.darkText
            label.font = UIFont.systemFont(ofSize: label.font.pointSize)
        }
    }
    
    
}

/// Tableview with the actual contents
class MenuTableViewController: UITableViewController {

    // Delegate for menu selection
    var menuDelegate: MenuSelectionDelegate?
    
    var menuItems: [MenuItem] = [.Budget, .Accounts, .Reports, .Export]
    
    /// Use this method to configure the View controller appropriately.
    internal static func instantiate() -> MenuTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuTableViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < menuItems.count else {
            fatalError("Selected menu item out of bounds")
        }
        
        
        
        let selectedItem = menuItems[indexPath.row]
        menuDelegate?.didSelectMenuItem(item: selectedItem)
    }
}

