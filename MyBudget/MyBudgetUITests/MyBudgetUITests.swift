//
//  MyBudgetUITests.swift
//  MyBudgetUITests
//
//  Created by Johannes on 05.09.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import XCTest

class MyBudgetUITests: XCTestCase {

    var snapshotCounter = 0
    
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
   
    func snapshotAndIncrement() {
        snapshotCounter += 1
        snapshot("Snapshot_\(snapshotCounter)")
    }
    
    func testFastlaneScreenshots() {
        // Use recording to get started writing UI tests.
        XCUIDevice.shared.orientation = .portrait
        
        let app = XCUIApplication()
        sleep(1)
        app.staticTexts["Continue"].tap()
        sleep(2)
        snapshotAndIncrement()
        app.staticTexts["Continue"].tap()
        
        sleep(1)
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).otherElements.containing(.textField, identifier:"Category").element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).otherElements.containing(.textField, identifier:"Category").element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 6).textFields["Category"].tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 8).otherElements.containing(.textField, identifier:"Category").element.tap()
        snapshotAndIncrement()
        app.staticTexts["Continue"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 1).children(matching: .button).element.tap()
        let textField = app.textFields["0,00 €"]
        textField.tap()
        textField.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["5"]/*[[".buttons[\"5\"].staticTexts[\"5\"]",".staticTexts[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["0"].tap()
        app.staticTexts["0"].tap()

        let staticText = app.textFields["Giro account"]
        staticText.tap()
        staticText.typeText("Example account")
        snapshotAndIncrement()
        app.buttons["Create account"].tap()
        
        snapshotAndIncrement()
        app.staticTexts["Continue"].tap()

        sleep(1)
        snapshotAndIncrement()
        app.staticTexts["Continue"].tap()

        sleep(1)
        snapshotAndIncrement()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Accounts"].tap()
        snapshotAndIncrement()
        tabBarsQuery.buttons["Spendings"].tap()
        snapshotAndIncrement()
        tabBarsQuery.buttons["Transactions"].tap()
        snapshotAndIncrement()

        tabBarsQuery.buttons["Budget"].tap()
        app.navigationBars["Budget"].buttons["info.circle"].tap()
        let scrollView = app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        snapshotAndIncrement()
        scrollView.swipeDown()

        
        app.buttons["Add new transaction"].tap()
        snapshotAndIncrement()

        app.otherElements["New Income"].tap()
        app.buttons["5"].tap()
        app.buttons["0"].tap()
        app.buttons["0"].tap()
        app.buttons["0"].tap()
        app.staticTexts["Done"].tap()
        
        app.tables.staticTexts["Cash"].firstMatch.tap()
        snapshotAndIncrement()
        
    }

}
