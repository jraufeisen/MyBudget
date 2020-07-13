//
//  TransactionSearchResultHeaderView.swift
//  MyBudget
//
//  Created by Johannes on 30.11.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit
import Swift_Ledger

class TransactionSearchResultHeaderView: UIScrollView {

    let offset: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var cards = [UIView]() {
        didSet {
            // Recalculate content size
            contentSize = CGSize.init(width: CGFloat(cards.count) * frame.width, height: frame.height)
        }
    }
    
    private func setup() {
        isPagingEnabled = true
    }
 

    func addTotalCard(income: Money, expense: Money) {
        let totalCard = TotalStatementCard.init(frame: CGRect.init(x: 0, y: 0, width: frame.width - offset, height: frame.height - offset))
        totalCard.setChart(income: income, expense: expense, label: "Total chart")
        totalCard.titleLabel.text = NSLocalizedString("Total", comment: "As in: total balance of all your accounts")
        let centerX = frame.width/2 + (frame.width)*CGFloat(cards.count)
        totalCard.center = CGPoint.init(x: centerX, y: frame.height/2)
        cards.append(totalCard)
        addSubview(totalCard)
    }
    
    func addPerMonthSpending(expenses: [BarChartMoneyEntry]) {
        let card = PerMonthSpendingCard.init(frame: CGRect.init(x: 0, y: 0, width: frame.width - offset, height: frame.height - offset))
        let centerX = frame.width/2 + (frame.width)*CGFloat(cards.count)
        card.center = CGPoint.init(x: centerX, y: frame.height/2)
        card.addChart(expenses: expenses)
        cards.append(card)
        addSubview(card)
    }
    
    func addPerMonthIncome(incomes: [BarChartMoneyEntry]) {
        let card = PerMonthIncomeCard.init(frame: CGRect.init(x: 0, y: 0, width: frame.width - offset, height: frame.height - offset))
        let centerX = frame.width/2 + (frame.width)*CGFloat(cards.count)
        card.center = CGPoint.init(x: centerX, y: frame.height/2)
        card.addChart(incomes: incomes)
        cards.append(card)
        addSubview(card)
    }
    
    func addPerCategorySpending(spendingsPerCategory: [String: Money]) {
        let card = PerCategorySpending.init(frame: CGRect.init(x: 0, y: 0, width: frame.width - offset, height: frame.height - offset))
        let centerX = frame.width/2 + (frame.width)*CGFloat(cards.count)
        card.center = CGPoint.init(x: centerX, y: frame.height/2)
        card.addChart(spendingsForCategory: spendingsPerCategory)
        cards.append(card)
        addSubview(card)
    }

}
