//
//  MyBudgetUITests.swift
//  MyBudgetUITests
//
//  Created by Johannes on 05.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import XCTest

class MyBudgetUITests: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["shouldAlwaysShowOnboarding"]
        app.launchArguments += ["noTouchID"]
        app.launchArguments += ["UITests"]
        app.launchArguments += ["-AppleLanguages",
        "(de)",
        "-AppleLocale",
        "de_DE"]

        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testmore() {
        
    }
    
    func testFastlaneScreenshots() {
        // Use recording to get started writing UI tests.
        XCUIDevice.shared.orientation = .portrait
        
        let app = XCUIApplication()
        snapshot("1Onboard")
        app.swipeLeft()
        snapshot("2Onboard")
        app.swipeLeft()
        snapshot("3Onboard")
        app.swipeLeft()
        snapshot("4Onboard")
        app.swipeLeft()

        app.buttons["Add new transaction"].tap()
        snapshot("9FloatyUnsubscribed")

        
        app.otherElements["New Expense"].tap()
        sleep(1)
        let button2 = app.buttons["1"]
        button2.tap()
        app.buttons["7"].tap()
        let button3 = app.buttons["4"]
        button3.tap()
        let button4 = app.buttons["2"]
        button4.tap()
        snapshot("10AddExpense")
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        let stopButton = app.navigationBars["Budget_.EnterNumberView"].firstMatch.buttons["Stop"]
        stopButton.tap()
        
        app.buttons["Add new transaction"].tap()
        app.otherElements["New Transfer"].tap()
        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "I will never ever exist!")], timeout: 0.5)
        app.buttons["5"].tap()
        app.buttons["8"].tap()
        app.buttons["0"].tap()
        snapshot("11AddTransfer")
        doneButton.tap()
        stopButton.tap()

        app.buttons["Add new transaction"].tap()
        app.otherElements["New Income"].tap()
        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "I will never ever exist!")], timeout: 0.5)
        button2.tap()
        button4.tap()
        app.buttons["3"].tap()
        button3.tap()
        snapshot("12AddIncome")
        doneButton.tap()
        stopButton.tap()

        app.buttons["Add new transaction"].tap()
        app.otherElements["Subscribe"].tap()
        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "I will never ever exist!")], timeout: 0.5)
        snapshot("13SubscriptionInfo")
        app.buttons["Learn More"].tap()
        app.buttons["1 Month for 1,09€"].tap()
        snapshot("14SubscriptionPrices")
        app.otherElements["Close"].tap()
        
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Budget"].tap()
        snapshot("5BudgetTabbar")
        tabBarsQuery.buttons["Accounts"].tap()
        snapshot("6AccountTabbar")
        tabBarsQuery.buttons["Spendings"].tap()
        snapshot("7SpendingsTabbar")
        tabBarsQuery.buttons["Transactions"].tap()
        snapshot("8TransactionsTabbar")

    }

}
