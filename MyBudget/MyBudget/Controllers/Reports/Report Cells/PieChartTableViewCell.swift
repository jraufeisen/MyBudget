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

        var pieEntries = [PieChartDataEntry]()
        
        for entry in entries {
            pieEntries.append(PieChartDataEntry.init(value: entry.money.floatValue, label: entry.label))
        }
        
        let pieChart = PieChartView.init(frame: chartContainer.frame)
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
        pieChart.drawCenterTextEnabled = true
        pieChart.centerText = "January 2019"
        
        let newFrame = CGRect(x: 0, y:0, width: self.frame.width, height: self.frame.height - 20)
    
        let card = PieChartCard.init(frame: newFrame)
        card.frame.size = CGSize(width: card.frame.width - 50, height: card.frame.height - 20)
        card.center = CGPoint(x: self.center.x + self.frame.width * CGFloat(numberOfCharts) , y:self.center.y)
        
        card.layer.cornerRadius = 10
        card.layer.masksToBounds = true // The rounded corner a valid for the whole card. Nothing can reach over it.
        
        card.addSubview(pieChart)
        chartContainer.addSubview(card)
        numberOfCharts += 1

        chartContainer.contentSize = CGSize(width: CGFloat(numberOfCharts)*self.frame.width, height: self.frame.height)

    }
    
}
