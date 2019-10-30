//
//  IncomeStatementTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 29.10.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger
import Charts

class IncomeStatementTableViewCell: UITableViewCell {

    static let Identifier = "IncomeStatementTableViewCellID"
    
    @IBOutlet weak var scrollView: UIScrollView!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        
        backgroundColor = .clear // Cell is clear, the cards will provide a background
        
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: CGFloat(1)*self.frame.width, height: self.frame.height)

    }


    /// The real chart data. use this to update the cells content.
    private var chartData = [IncomeStatementData]()
    
    /// Public setter which acts as a "gateway" to the eral chartdata.
    var data = [IncomeStatementData]() {
        didSet {
            if data != chartData { // Only update cell if content changed
                chartData = data
                updateContent()
            }
        }
    }

    private func updateContent() {
        reset()
        for data in chartData {
            addChart(income: data.income, expense: data.expense, label: data.name)
        }
        scrollView.setContentOffset(CGPoint.init(x: scrollView.contentSize.width - scrollView.frame.width, y: 0), animated: false) // We set the content offset

    }
    
    private var numberOfCharts = 0
    private func reset() {
        numberOfCharts = 0
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func addChart(income: Money, expense: Money, label: String) {

        let cardOffsetX: CGFloat = 25
        let cardOffsetY: CGFloat = 20
        
        let newFrame = CGRect(x: 0, y:0, width: self.frame.width - 2*cardOffsetX, height: self.frame.height - 2*cardOffsetY)
        let card = IncomeStatementCard.init(frame: newFrame)
        card.center = CGPoint(x: self.center.x + self.frame.width * CGFloat(numberOfCharts) , y: self.bounds.height / 2)
        card.titleLabel.text = label
        
        card.incomeAmountLabel.text = "\(income)"
        card.expenseAmountLabel.text = "\(expense)"
        
        var pieEntries = [PieChartDataEntry]()
        
      
        pieEntries.append(PieChartDataEntry.init(value: income.floatValue, label: "Income"))
        pieEntries.append(PieChartDataEntry.init(value: expense.floatValue, label: "Expense"))

        
        let pieChart = PieChartView.init(frame: card.chartContainer.frame)
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
        
        scrollView.addSubview(card)
        
        card.chartContainer.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        // Align pie chart to its container
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: pieChart, attribute: .top, relatedBy: .equal, toItem: card.chartContainer, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .left, relatedBy: .equal, toItem: card.chartContainer, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .right, relatedBy: .equal, toItem: card.chartContainer, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: pieChart, attribute: .bottom, relatedBy: .equal, toItem: card.chartContainer, attribute: .bottom, multiplier: 1, constant: 0),
        ])


        numberOfCharts += 1

        scrollView.contentSize = CGSize(width: CGFloat(numberOfCharts)*self.frame.width, height: self.frame.height)

        
    }
    
    
}
