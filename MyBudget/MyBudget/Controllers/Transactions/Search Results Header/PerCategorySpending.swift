//
//  PerCategorySpending.swift
//  MyBudget
//
//  Created by Johannes on 01.12.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Charts
import Swift_Ledger

class PerCategorySpending: UIView {

   @IBOutlet weak var chartContainer: UIView!
   @IBOutlet weak var contentView: UIView!
   @IBOutlet weak var titleLabel: UILabel!

   @IBOutlet weak var label1: UILabel!
   @IBOutlet weak var label2: UILabel!
   @IBOutlet weak var label3: UILabel!
   @IBOutlet weak var label4: UILabel!
   @IBOutlet weak var label5: UILabel!

   override init(frame: CGRect) {
       super.init(frame: frame)
       commonInit()
   }
   
   
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       commonInit()
   }
   
   private func commonInit() {
       Bundle.main.loadNibNamed("PerCategorySpending", owner: self, options: nil)
       addSubview(contentView)
       contentView.frame = self.bounds
       contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       if #available(iOS 13.0, *) {
           contentView.backgroundColor = .secondarySystemGroupedBackground
       } else {
           contentView.backgroundColor = UIColor.lightGray
       }
       
       layer.cornerRadius = 10
       contentView.layer.cornerRadius = 10
       layer.shadowColor = UIColor.init(white: 0, alpha: 1.0).cgColor
       layer.shadowRadius = 5
       layer.shadowOffset = CGSize.init(width: 2, height: 5)
       layer.shadowOpacity = 0.3
   }

    
    func addChart(entries: [(money: Money, label: String)], chartName: String = "Expenses") {

       /* guard entries.count > 0 else {
            addSpecialCard(title: chartName, body: "Track your expenses to see detailed statistics about your spending behavior")
            return
        }*/
        
        let colors = [NSUIColor.systemRed, NSUIColor.systemBlue, NSUIColor.systemGreen, NSUIColor.systemOrange, NSUIColor.systemYellow]
        
        // Sort descending and name the biggest five categories
        let entries = entries.sorted(by: { (arg1, arg2) -> Bool in
            return arg2.money < arg1.money
        })
        let totalMoney: Double = entries.reduce(0) { (result, arg) -> Double in
            return result + arg.money.floatValue
        }

        if entries.count > 0 {
            let percent = Int(round(entries[0].money.floatValue / totalMoney * 100))
            label1.text = "\(percent) % " + entries[0].label
        } else {
            label1.text = ""
        }
        
        if entries.count > 1 {
            let percent = Int(round(entries[1].money.floatValue / totalMoney * 100))
            label2.text = "\(percent) % " + entries[1].label
            
        } else {
            label2.text = ""
        }
        
        if entries.count > 2 {
            let percent = Int(round(entries[2].money.floatValue / totalMoney * 100))
            label3.text = "\(percent) % " + entries[2].label
        } else {
            label3.text = ""
        }
        
        if entries.count > 3 {
            let percent = Int(round(entries[3].money.floatValue / totalMoney * 100))
            label4.text = "\(percent) % " + entries[3].label
        } else {
            label4.text = ""
        }
        
        if entries.count > 4 {
            let percent = Int(round(entries[4].money.floatValue / totalMoney * 100))
            label5.text = "\(percent) % " + entries[4].label
        } else {
            label5.text = ""
        }
        
        var pieEntries = [PieChartDataEntry]()
        for entry in entries {
            pieEntries.append(PieChartDataEntry.init(value: entry.money.floatValue, label: entry.label))
        }
        let pieChart = PieChartView.init(frame: chartContainer.frame)
        pieChart.frame.origin = CGPoint.zero
        let dataSet = PieChartDataSet.init(entries: pieEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.colors = colors
        let data = PieChartData.init(dataSet: dataSet)
        pieChart.data = data
        pieChart.legend.enabled = false
        pieChart.rotationEnabled = false
        pieChart.highlightPerTapEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.drawHoleEnabled = true
        pieChart.holeColor = .clear
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.65
        pieChart.transparentCircleColor = .clear
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.addSubview(pieChart)
        // Align pie chart to its container
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: pieChart, attribute: .top, relatedBy: .equal, toItem: chartContainer, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .left, relatedBy: .equal, toItem: chartContainer, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .right, relatedBy: .equal, toItem: chartContainer, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .bottom, relatedBy: .equal, toItem: chartContainer, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
    }

    
    
    
}
