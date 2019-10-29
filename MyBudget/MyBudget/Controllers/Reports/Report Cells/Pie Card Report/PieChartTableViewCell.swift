//
//  PieChartTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 27.10.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Charts
import Swift_Ledger

class PieChartTableViewCell: UITableViewCell {

    static let Identifier = "PieChartTableViewCellID"
    
    @IBOutlet weak var chartContainer: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        backgroundColor = .clear // Cell is clear, the cards will provide a background
        
        chartContainer.isPagingEnabled = true
        chartContainer.contentSize = CGSize(width: CGFloat(1)*self.frame.width, height: self.frame.height)

    }

    
    private var numberOfCharts = 0
    
    func addChart(entries: [(money: Money, label: String)]) {

        let cardOffsetX: CGFloat = 25
        let cardOffsetY: CGFloat = 20
        
        let newFrame = CGRect(x: 0, y:0, width: self.frame.width - 2*cardOffsetX, height: self.frame.height - 2*cardOffsetY)
        let card = PieChartCard.init(frame: newFrame)
        card.center = CGPoint(x: self.center.x + self.frame.width * CGFloat(numberOfCharts) , y:self.center.y)
        
        
        var pieEntries = [PieChartDataEntry]()
        
        for entry in entries {
            pieEntries.append(PieChartDataEntry.init(value: entry.money.floatValue, label: entry.label))
        }
        
        let pieChart = PieChartView.init(frame: card.chartContainer.frame)
        pieChart.frame.origin = CGPoint.zero
        
        let dataSet = PieChartDataSet.init(entries: pieEntries, label: "")
        dataSet.drawValuesEnabled = false
        
        dataSet.colors = [NSUIColor.systemRed, NSUIColor.systemBlue, NSUIColor.systemGreen, NSUIColor.systemOrange]
        
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
        
        chartContainer.addSubview(card)
        
        
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

        chartContainer.contentSize = CGSize(width: CGFloat(numberOfCharts)*self.frame.width, height: self.frame.height)

    }
    
}
