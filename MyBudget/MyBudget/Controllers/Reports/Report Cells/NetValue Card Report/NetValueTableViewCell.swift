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

    private var explainLabel: UILabel?
    let oneMonthWidth: CGFloat = 100

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        backgroundColor = .clear
        if #available(iOS 13.0, *) {
            contentContainer.backgroundColor = .secondarySystemGroupedBackground
        } else {
            contentContainer.backgroundColor = UIColor.white
        }

        contentContainer.layer.cornerRadius = 10
        contentContainer.layer.cornerRadius = 10
         
        contentContainer.layer.shadowColor = UIColor.init(white: 0, alpha: 1).cgColor
        contentContainer.layer.shadowRadius = 5
        contentContainer.layer.shadowOffset = CGSize.init(width: 2, height: 5)
        contentContainer.layer.shadowOpacity = 0.3
    }

    /// The real chart data. use this to update the cells content.
    private var chartData = [NetValueData]()
   
    /// Public setter which acts as a "gateway" to the eral chartdata.
    var data = [NetValueData]() {
        didSet {
            if data != chartData || data.count == 0 { // Only update cell if content changed
               chartData = data
               updateContent()
           }
       }
    }
    
    private func updateContent() {
        reset()
        
        guard chartData.count > 0 else {
            addNoDataInfo()
            return
        }
        
        addChart(entries: chartData)
                
    }
    
    private func addNoDataInfo() {
        let explainLabel = UILabel(frame: scrollView.bounds)
        if #available(iOS 13.0, *) {
            explainLabel.textColor = .secondaryLabel
        }
        explainLabel.textAlignment = .center
        explainLabel.text = "Check back regularly to see how your net value developes over time"


        explainLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(explainLabel)

        explainLabel.numberOfLines = 5
        contentContainer.addSubview(explainLabel)

        // Center label in card
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: explainLabel, attribute: .leading, relatedBy: .equal, toItem: contentContainer, attribute: .leading, multiplier: 1, constant: 15),
            NSLayoutConstraint.init(item: explainLabel, attribute: .trailing, relatedBy: .equal, toItem: contentContainer, attribute: .trailing, multiplier: 1, constant: -15),
            NSLayoutConstraint.init(item: explainLabel, attribute: .centerY, relatedBy: .equal, toItem: contentContainer, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
        self.explainLabel = explainLabel
    }

    private func reset() {
        explainLabel?.removeFromSuperview()
        
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func addDashedLinesChart(entries: [NetValueData]) {
        let totalNumberOfEntries = Int(scrollView.frame.width / oneMonthWidth)
        print(totalNumberOfEntries)
        
        var realChartEntries = [ChartDataEntry]()
        var fakeChartEntries = [ChartDataEntry]()
        for i in 0..<entries.count {
            let money = entries[i].value
            let newEntry = ChartDataEntry.init(x: Double(i), y: money.floatValue)
            realChartEntries.append(newEntry)
        }

        
        let money = entries[entries.count-1].value
        let newEntry = ChartDataEntry.init(x: Double(entries.count-1), y: money.floatValue)
        let lastEntry = ChartDataEntry.init(x: Double(100), y: money.floatValue) // Somewhere over the rainbow

        fakeChartEntries.append(newEntry)
        fakeChartEntries.append(lastEntry)

        
        let realDataSet = LineChartDataSet.init(entries: realChartEntries, label: "Net Value")
        let fakeDataSet = LineChartDataSet.init(entries: fakeChartEntries, label: "Predicted Net Value")

        for dataSet in [realDataSet, fakeDataSet] {
            dataSet.colors = [NSUIColor.incomeColor]
            dataSet.circleColors = [.incomeColor]
            dataSet.circleRadius = 4
            dataSet.valueFont = UIFont.systemFont(ofSize: 15)
            dataSet.circleHoleColor = .incomeColor
        }

        realDataSet.valueFormatter = NetValueChartMoneyFormatter()

        fakeDataSet.drawValuesEnabled = false
        fakeDataSet.lineDashLengths = [3,3]
        fakeDataSet.drawCirclesEnabled = false

        
        let combinedChart = CombinedChartView.init(frame: CGRect.zero)
        
        if #available(iOS 13.0, *) { // Adapt for dark mode
            realDataSet.valueColors = [UIColor.label]
            combinedChart.xAxis.labelTextColor = UIColor.label
        }

        let combinedData = CombinedChartData.init(dataSets: [realDataSet, fakeDataSet])
        combinedData.lineData = LineChartData.init(dataSets: [realDataSet, fakeDataSet])
        
        combinedChart.data = combinedData

        // General settings
        combinedChart.scaleXEnabled = false // No zooming
        combinedChart.scaleYEnabled = false // No zooming

        combinedChart.doubleTapToZoomEnabled = false
        combinedChart.dragEnabled = false
        combinedChart.legend.enabled = false
        combinedChart.rightAxis.enabled = false
        combinedChart.highlightPerTapEnabled = false
        
        combinedChart.xAxis.drawGridLinesEnabled = false
        combinedChart.xAxis.drawAxisLineEnabled = false
        combinedChart.xAxis.labelPosition = .bottomInside
        
        let labels = entries.map { (arg) -> String in
            return arg.label
        }
        
        combinedChart.xAxis.valueFormatter = NetValueChartXAxisFormatter(labels: labels)
        combinedChart.xAxis.setLabelCount(entries.count, force: false) // Do not force label count => Labels only for integer values

        combinedChart.xAxis.spaceMin = 0.5
        combinedChart.xAxis.spaceMax = 1

        combinedChart.leftAxis.drawGridLinesEnabled = false
        combinedChart.leftAxis.drawAxisLineEnabled = false
        combinedChart.leftAxis.drawLabelsEnabled = false

        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.contentSize.height) // No scrolling in this one!
        scrollView.addSubview(combinedChart)
        // Constraint linechart to scrollview
        combinedChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: combinedChart, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: combinedChart, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: combinedChart, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: combinedChart, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: oneMonthWidth*CGFloat(100)), // Some large constant
        ])
    }
    
    private func addChart(entries: [NetValueData]) {
        if CGFloat(entries.count) * oneMonthWidth < scrollView.frame.width {
            // Use an alternative chart with dashed lines to fill the view
            addDashedLinesChart(entries: entries)
            return
        }
        
        var chartEntries = [ChartDataEntry]()
        for i in 0..<entries.count {
            let money = entries[i].value
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

        if #available(iOS 13.0, *) { // Adapt for dark mode
            dataSet.valueColors = [UIColor.label]
            lineChart.xAxis.labelTextColor = UIColor.label
        }

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

        if scrollView.contentSize.width > scrollView.frame.width {
            // We cant use scrollRectToVisible() yet, so we set the content offset.
            // But also dont force a scrollview to scroll farther than it would naturally allow oyu to
            scrollView.setContentOffset(CGPoint.init(x: scrollView.contentSize.width - scrollView.frame.width, y: 0), animated: false)
        }
    }
    
}

/// Returns empty string when value is zero.
class NetValueChartMoneyFormatter: NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Money(value))"
    }
    
}

/// Returns the ith element of initialized array of labels
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
