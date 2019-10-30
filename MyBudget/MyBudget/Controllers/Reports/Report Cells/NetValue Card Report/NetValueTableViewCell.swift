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
        

    }

    /// The real chart data. use this to update the cells content.
   private var chartData = [(Money, String)]()
   
   /// Public setter which acts as a "gateway" to the eral chartdata.
    var data = [(Money, String)]() {
        didSet {
            if data.count != chartData.count { // Only update cell if content changed
               chartData = data
               updateContent()
           }
       }
    }
    
    private func updateContent() {
        reset()
        addChart(entries: chartData)
        scrollView.setContentOffset(CGPoint.init(x: scrollView.contentSize.width - scrollView.frame.width, y: 0), animated: false) // We cant use scrollRectToVisible() yet, so we set the content offset
    }
    
    
    private func reset() {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func addChart(entries: [(money: Money, label: String)]) {

        let oneMonthWidth: CGFloat = 100
        
        var chartEntries = [ChartDataEntry]()
        for i in 0..<entries.count {
            let money = entries[i].money
            let newEntry = ChartDataEntry.init(x: Double(i), y: money.floatValue)
            chartEntries.append(newEntry)
        }
        
        let dataSet = LineChartDataSet.init(entries: chartEntries, label: "Net Value")
        
        dataSet.colors = [NSUIColor.incomeColor]
        dataSet.circleColors = [.incomeColor]
        dataSet.circleRadius = 4
        dataSet.valueFont = UIFont.systemFont(ofSize: 15)
        dataSet.circleHoleColor = .incomeColor
        dataSet.valueFormatter = NetValueChartMoneyFormatter()
        
        let data = LineChartData.init(dataSet: dataSet)
        let lineChart = LineChartView.init(frame: CGRect.zero) // Frame will later be set by constraints
        lineChart.data = data

        // General settings
        lineChart.scaleXEnabled = false // No zooming
        lineChart.scaleYEnabled = false // No zooming

        lineChart.doubleTapToZoomEnabled = false
        lineChart.dragEnabled = false
        lineChart.legend.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.highlightPerTapEnabled = false
        
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.labelPosition = .bottomInside
        
        let labels = entries.map { (arg) -> String in
            return arg.label
        }
        
        lineChart.xAxis.valueFormatter = NetValueChartXAxisFormatter(labels: labels)
        lineChart.xAxis.setLabelCount(entries.count, force: false) // Do not force label count => Labels only for integer values

        
        lineChart.xAxis.spaceMin = 1
        lineChart.xAxis.spaceMax = 1
    

        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = false

        

        scrollView.contentSize = CGSize(width: oneMonthWidth*CGFloat(entries.count), height: scrollView.contentSize.height)
        scrollView.addSubview(lineChart)
        // Constraint linechart to scrollview
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: lineChart, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: lineChart, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: lineChart, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: lineChart, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: oneMonthWidth*CGFloat(entries.count)),
        ])

    }
    
}

/// Returns empty string when value is zero.
class NetValueChartMoneyFormatter: NSObject, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Money(value))"
    }
}

class NetValueChartXAxisFormatter: NSObject, IAxisValueFormatter {
    
    private let labels: [String]
    init(labels: [String]) {
        self.labels = labels
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let x = Int(value)
        
        guard x < labels.count && x >= 0 else {
            return ""
        }
        
        return labels[x]
    }
}
