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
    
    @IBOutlet weak var chartContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupChart(entries: [(400, "Rent"), (100, "Groceries")])
    }

    func setupChart(entries: [(money: Money, label: String)]) {

        var pieEntries = [PieChartDataEntry]()
        
        for entry in entries {
            pieEntries.append(PieChartDataEntry.init(value: entry.money.floatValue, label: entry.label))
        }
        
        let pieChart = PieChartView.init(frame: chartContainer.frame)
        pieChart.frame.origin = CGPoint.zero
        let dataSet = PieChartDataSet.init(entries: pieEntries, label: "")
        //let data = ChartData.init(dataSet: dataSet)
        let data = PieChartData.init(dataSet: dataSet)
        
        pieChart.data = data

        chartContainer.addSubview(pieChart)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
