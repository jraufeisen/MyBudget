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
    
    func reset() {
        numberOfCharts = 0
        for subview in chartContainer.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func addChart(entries: [(money: Money, label: String)], chartName: String = "Expenses") {

        let cardOffsetX: CGFloat = 25
        let cardOffsetY: CGFloat = 20
        
        let colors = [NSUIColor.systemRed, NSUIColor.systemBlue, NSUIColor.systemGreen, NSUIColor.systemOrange, NSUIColor.systemYellow]
        
        let newFrame = CGRect(x: 0, y:0, width: self.frame.width - 2*cardOffsetX, height: self.frame.height - 2*cardOffsetY)
        let card = PieChartCard.init(frame: newFrame)
        card.center = CGPoint(x: self.center.x + self.frame.width * CGFloat(numberOfCharts) , y: self.bounds.height / 2)
        card.titleLabel.text = chartName
        
        
        
        // Sort descending and name the biggest five categories
        let entries = entries.sorted(by: { (arg1, arg2) -> Bool in
            return arg2.money < arg1.money
        })
        let totalMoney: Double = entries.reduce(0) { (result, arg) -> Double in
            return result + arg.money.floatValue
        }
        

        if entries.count > 0 {
            let percent = Int(round(entries[0].money.floatValue / totalMoney * 100))
            card.label1.text = "\(percent) % " + entries[0].label
        } else {
            card.label1.text = ""
        }
        
        if entries.count > 1 {
            let percent = Int(round(entries[1].money.floatValue / totalMoney * 100))
            card.label2.text = "\(percent) % " + entries[1].label
            
        } else {
            card.label2.text = ""
        }
        
        if entries.count > 2 {
            let percent = Int(round(entries[2].money.floatValue / totalMoney * 100))
            card.label3.text = "\(percent) % " + entries[2].label
        } else {
            card.label3.text = ""
        }
        
        if entries.count > 3 {
            let percent = Int(round(entries[3].money.floatValue / totalMoney * 100))
            card.label4.text = "\(percent) % " + entries[3].label
        } else {
            card.label5.text = ""
        }
        
        if entries.count > 4 {
            let percent = Int(round(entries[4].money.floatValue / totalMoney * 100))
            card.label5.text = "\(percent) % " + entries[4].label
        } else {
            card.label5.text = ""
        }
        
        
        var pieEntries = [PieChartDataEntry]()
        
        for entry in entries {
            pieEntries.append(PieChartDataEntry.init(value: entry.money.floatValue, label: entry.label))
        }
        
        let pieChart = PieChartView.init(frame: card.chartContainer.frame)
        pieChart.frame.origin = CGPoint.zero
        
        let dataSet = PieChartDataSet.init(entries: pieEntries, label: "")
        dataSet.drawValuesEnabled = false
        
        dataSet.colors = colors
        
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
