//
//  NetValueTableViewCell.swift
//  MyBudget
//
//  Created by Johannes on 29.10.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger
import Charts

class NetValueTableViewCell: UITableViewCell {

    static let Identifier = "NetValueChartTableViewCellID"

    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    
    override func awakeFromNib() {
        super.awakeFromNib()


        selectionStyle = .none
        backgroundColor = .clear
        if #available(iOS 13.0, *) {
            contentContainer.backgroundColor = .secondarySystemBackground
        } else {
            contentContainer.backgroundColor = UIColor.lightGray
        }

        contentContainer.layer.cornerRadius = 10
        contentContainer.layer.cornerRadius = 10
         
         
        contentContainer.layer.shadowColor = UIColor.lightGray.cgColor
        contentContainer.layer.shadowRadius = 5
        contentContainer.layer.shadowOffset = CGSize.init(width: 2, height: 5)
        contentContainer.layer.shadowOpacity = 0.7

        
        
        let oneMonthWidth: CGFloat = 100
        scrollView.contentSize = CGSize(width: CGFloat(10)*oneMonthWidth, height: scrollView.contentSize.height)


    }

    func reset() {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func addChart(entries: [(money: Money, label: String)]) {

        var chartEntries = [ChartDataEntry]()
        for i in 0..<entries.count {
            let money = entries[i].money
            let newEntry = ChartDataEntry.init(x: Double(i), y: money.floatValue)
            chartEntries.append(newEntry)
        }
        
        let dataSet = LineChartDataSet.init(entries: chartEntries, label: "Money")
        
        dataSet.colors = [NSUIColor.incomeColor]
        dataSet.circleColors = [.incomeColor]
        dataSet.circleRadius = 4
        dataSet.valueFont = UIFont.systemFont(ofSize: 15)
        dataSet.circleHoleColor = .incomeColor
        
        let data = LineChartData.init(dataSet: dataSet)
        let lineChart = LineChartView.init(frame: CGRect.init(x: 0, y: 0, width: 1000, height: scrollView.frame.height))
        lineChart.data = data

        // General settings
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
        lineChart.dragEnabled = false
        lineChart.legend.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.highlightPerTapEnabled = false

        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.drawLabelsEnabled = false
        lineChart.xAxis.spaceMin = 0.1
        lineChart.xAxis.spaceMax = 0.1
    

            
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = false

        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(lineChart)
        
        // Constraint linechart to scrollview
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: lineChart, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: lineChart, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: lineChart, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: lineChart, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1000),
        ])

    }
    
}
