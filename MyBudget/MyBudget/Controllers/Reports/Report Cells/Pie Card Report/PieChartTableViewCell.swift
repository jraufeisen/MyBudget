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
    
    let cardOffsetX: CGFloat = 25
    let cardOffsetY: CGFloat = 20

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        backgroundColor = .clear // Cell is clear, the cards will provide a background
        
        chartContainer.isPagingEnabled = true

        chartContainer.contentSize = CGSize(width: CGFloat(1)*self.frame.width, height: self.frame.height)

        // Load up with placeholder card "Reports are loaded"
        addPlaceholderCard()
    }

    private func addPlaceholderCard() {
        let newFrame = CGRect(x: 0, y:0, width: self.frame.width - 2*cardOffsetX, height: self.frame.height - 2*cardOffsetY)
        let card = PieChartCard.init(frame: newFrame)
        card.center = CGPoint(x: self.center.x, y: self.bounds.height / 2)
        card.titleLabel.text = NSLocalizedString("Spendings", comment: "Heading for a diagramm")
        card.label1.text = ""
        card.label2.text = ""
        card.label3.text = ""
        card.label4.text = ""
        card.label5.text = ""

        let activityIndicator = UIActivityIndicatorView.init(frame: card.chartContainer.bounds)
        activityIndicator.startAnimating()
        card.chartContainer.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Center activity indicator in card
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: card, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: card, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
        chartContainer.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        // Programmatically set card's frame including all offsets from the sides
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: card, attribute: .height, relatedBy: .equal, toItem: chartContainer, attribute: .height, multiplier: 1, constant: -2*cardOffsetY),
            NSLayoutConstraint.init(item: card, attribute: .width, relatedBy: .equal, toItem: chartContainer, attribute: .width, multiplier: 1, constant: -2*cardOffsetX),
            NSLayoutConstraint.init(item: card, attribute: .centerX, relatedBy: .equal, toItem: chartContainer, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: card, attribute: .centerY, relatedBy: .equal, toItem: chartContainer, attribute: .centerY, multiplier: 1, constant: 0),
        ])
    }
    
    
    /// The real chart data. use this to update the cells content.
    private var chartData = [PieChartSpendingsData]()
    
    /// Public setter which acts as a "gateway" to the eral chartdata.
    var data = [PieChartSpendingsData]() {
        didSet {
            if data != chartData || data.count == 0 { // Only update cell if content changed
                chartData = data
                updateContent()
            }
        }
    }
    
    /// Current number of charts
    private var numberOfCharts = 0
    
    private func reset() {
        numberOfCharts = 0
        for subview in chartContainer.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func updateContent() {
        reset()
        guard chartData.count > 0 else {
            addNoDataCard()
            return
        }
        
        for data in chartData {
            addChart(entries: data.entries, chartName: data.label)
        }
        
        chartContainer.scrollRectToVisible(CGRect(x: chartContainer.contentSize.width - 10, y: 0, width: 10, height: chartContainer.frame.height), animated: false)
    }
    
    private func addSpecialCard(title: String, body: String) {
        let newFrame = CGRect(x: 0, y:0, width: self.frame.width - 2*cardOffsetX, height: self.frame.height - 2*cardOffsetY)
        let card = PieChartCard.init(frame: newFrame)
        card.center = CGPoint(x: self.center.x, y: self.bounds.height / 2)
        card.titleLabel.text = title
        card.label1.text = ""
        card.label2.text = ""
        card.label3.text = ""
        card.label4.text = ""
        card.label5.text = ""

        let explainLabel = UILabel(frame: card.chartContainer.bounds)
        if #available(iOS 13.0, *) {
            explainLabel.textColor = .secondaryLabel
        }
        explainLabel.textAlignment = .center
        explainLabel.text = body
        card.chartContainer.addSubview(explainLabel)
        explainLabel.translatesAutoresizingMaskIntoConstraints = false
        explainLabel.numberOfLines = 5
        // Center label in card
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: explainLabel, attribute: .leading, relatedBy: .equal, toItem: card.titleLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: explainLabel, attribute: .trailing, relatedBy: .equal, toItem: card, attribute: .trailing, multiplier: 1, constant: -15),
            NSLayoutConstraint.init(item: explainLabel, attribute: .centerY, relatedBy: .equal, toItem: card, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
        chartContainer.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        // Programmatically set card's frame including all offsets from the sides
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: card, attribute: .height, relatedBy: .equal, toItem: chartContainer, attribute: .height, multiplier: 1, constant: -2*cardOffsetY),
            NSLayoutConstraint.init(item: card, attribute: .width, relatedBy: .equal, toItem: chartContainer, attribute: .width, multiplier: 1, constant: -2*cardOffsetX),
            NSLayoutConstraint.init(item: card, attribute: .centerX, relatedBy: .equal, toItem: chartContainer, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: card, attribute: .centerY, relatedBy: .equal, toItem: chartContainer, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
        // Update content size
        chartContainer.contentSize = CGSize(width: CGFloat(1)*self.frame.width, height: self.frame.height)
    }
    
    private func addNoDataCard() {
        addSpecialCard(title: NSLocalizedString("Spendings", comment: "Heading of a diagramm"), body: NSLocalizedString("Track your expenses to see detailed statistics about your spending behavior", comment: ""))
    }
    
    private func addChart(entries: [(money: Money, label: String)], chartName: String = "Expenses") {

        guard entries.count > 0 else {
            addSpecialCard(title: chartName, body: NSLocalizedString("Track your expenses to see detailed statistics about your spending behavior", comment: ""))
            return
        }
        
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
            card.label4.text = ""
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
