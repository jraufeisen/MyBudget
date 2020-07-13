//
//  PerMonthSpendingCard.swift
//  MyBudget
//
//  Created by Johannes on 01.12.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Charts
import Swift_Ledger

class PerMonthIncomeCard: UIView {
    
    let oneMonthWidth: CGFloat = 75

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var chartContainer: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PerMonthIncomeCard", owner: self, options: nil)
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
        
        var entries = [BarChartDataEntry]()
        for i in 0..<20 {
            let entry = BarChartDataEntry.init(x: Double(i), y:Double(i))
            entries.append(entry)
        }
    }

    func addChart(incomes: [BarChartMoneyEntry]) {
        guard incomes.count > 0 else { return }

        let sum: Money = incomes.reduce(0) { (res, entry) -> Money in
            return res + entry.money
        }
        let avg = sum.floatValue / Double(incomes.count)
        
        var entries = [BarChartDataEntry]()
        for i in 0..<incomes.count {
            let income = incomes[i]
            let entry = BarChartDataEntry.init(x: Double(i), y: income.money.floatValue)
            entries.append(entry)
        }
        
        let labels: [String] = incomes.map { (income) -> String in
            return income.label
        }
        
        addGraph(entries: entries, avgValue: avg, labels: labels)
    }
    
    private func addGraph(entries: [BarChartDataEntry], avgValue: Double, labels: [String]) {
        subtitleLabel.text = String.init(format: NSLocalizedString("Average income: %@", comment: "%@ stands for a monetary value"), "\(Money(avgValue))")
        
        // Calculate data and dataset
        let chart = CombinedChartView.init(frame: CGRect.init(x: 0, y: 0, width: chartContainer.frame.width, height: chartContainer.frame.height))
        let dataSet = BarChartDataSet.init(entries: entries, label: "Income")
        dataSet.colors = [NSUIColor.incomeColor]
        let nonZeroEntries = dataSet.filter { (entry) -> Bool in
            entry.y != 0
        }
        let containsNonZeroExpense = nonZeroEntries.count > 0
        

        let data = CombinedChartData.init(dataSets: [dataSet])
        if containsNonZeroExpense {
            data.barData = BarChartData.init(dataSet: dataSet)
        }
        
        data.setValueFormatter(BudgetChartMoneyFormatter())
        chart.data = data
        // Graph Colors
        chart.barData?.setValueTextColor(.gray)
        
        // General settings
        chart.rightAxis.enabled = false
        chart.pinchZoomEnabled = false

        chart.doubleTapToZoomEnabled = false
        chart.dragEnabled = false
        chart.legend.enabled = false
        chart.highlightPerTapEnabled = false
        chart.scaleXEnabled = false // No zooming
        chart.scaleYEnabled = false // No zooming

        // Bottom Axis
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.axisMinLabels = 1   // Default minimum is 2. But if we only wanna display one label, we gotta make this change
        chart.xAxis.labelCount = entries.count
        chart.xAxis.labelTextColor = .gray
        chart.xAxis.labelFont = UIFont.systemFont(ofSize: 8)
        chart.xAxis.valueFormatter = LabelsFormatter(labels: labels)
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        
        // Left Axis
        chart.leftAxis.labelTextColor = .gray
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.leftAxis.spaceBottom = 0.2
        chart.leftAxis.spaceTop = 0.7
        // Hack to "draw lines in the background while still having enough offset to the real data"
        // Average label must not interfere with labels of the bar chart.
        chart.xAxis.axisMinimum = -0.5
        chart.xAxis.axisMaximum = Double(entries.count-1) + 0.5

        chartContainer.contentSize = CGSize(width: oneMonthWidth*CGFloat(entries.count), height: chartContainer.contentSize.height)

        chart.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.addSubview(chart)

        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: chart, attribute: .height, relatedBy: .equal, toItem: chartContainer, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: chart, attribute: .left, relatedBy: .equal, toItem: chartContainer, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: chart, attribute: .top, relatedBy: .equal, toItem: chartContainer, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: chart, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: oneMonthWidth*CGFloat(entries.count)), // Some large constant
        ])
    }
    
}
