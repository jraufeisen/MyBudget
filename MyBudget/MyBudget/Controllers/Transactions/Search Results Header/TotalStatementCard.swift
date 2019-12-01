//
//  IncomeStatementCard.swift
//  MyBudget
//
//  Created by Johannes on 29.10.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger
import Charts

class TotalStatementCard: UIView {
    
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var chartContainer: UIView!
     @IBOutlet weak var contentView: UIView!

    
    @IBOutlet weak var incomeStationaryLabel: UILabel!
    @IBOutlet weak var expenseStationaryLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!

     override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }
     
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         commonInit()
     }
     
     private func commonInit() {
         Bundle.main.loadNibNamed("TotalStatementCard", owner: self, options: nil)
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
         
         layer.shadowColor = UIColor.init(white: 0, alpha: 1).cgColor
         layer.shadowRadius = 5
         layer.shadowOffset = CGSize.init(width: 2, height: 5)
         layer.shadowOpacity = 0.3
     }


    func setChart(income: Money, expense: Money, label: String) {
        incomeAmountLabel.text = "\(income)"
        expenseAmountLabel.text = "\(expense)"
        
        var pieEntries = [PieChartDataEntry]()
        pieEntries.append(PieChartDataEntry.init(value: income.floatValue, label: "Income"))
        pieEntries.append(PieChartDataEntry.init(value: expense.floatValue, label: "Expense"))
        
        let pieChart = PieChartView.init(frame: frame)
        pieChart.frame.origin = CGPoint.zero
        let dataSet = PieChartDataSet.init(entries: pieEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.colors = [NSUIColor.incomeColor, NSUIColor.expenseColor]
        
        //let data = ChartData.init(dataSet: dataSet)
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
        
        chartContainer.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        // Align pie chart to its container
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: pieChart, attribute: .top, relatedBy: .equal, toItem: chartContainer, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .left, relatedBy: .equal, toItem: chartContainer, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .right, relatedBy: .equal, toItem: chartContainer, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .bottom, relatedBy: .equal, toItem: chartContainer, attribute: .bottom, multiplier: 1, constant: 0),
        ])
    }

    
    
}
