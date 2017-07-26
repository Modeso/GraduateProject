//
//  Euroleague_GraduateUITests.swift
//  Euroleague-GraduateUITests
//
//  Created by Mohammed Elsammak on 7/7/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import XCTest

class Euroleague_GraduateUITests: XCTestCase {
    
    var app: XCUIApplication! = nil
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllTabsAreThere() {
        XCUIDevice.shared().orientation = .portrait
        let cellsQuery = app.collectionViews.cells
        let poElement = cellsQuery.otherElements.containing(.staticText, identifier:"PO").element
        let f4Element = cellsQuery.otherElements.containing(.staticText, identifier:"F4").element
        let rsElement = cellsQuery.otherElements.containing(.staticText, identifier:"RS").element
        
        if poElement.exists {
            poElement.tap()
            if f4Element.exists {
                f4Element.tap()
                if rsElement.exists {
                    rsElement.tap()
                    XCTAssertTrue(true)
                }
                else{
                    XCTAssertTrue(false)
                }
            }
            else{
                XCTAssertTrue(false)
            }
        }
        else{
            XCTAssertTrue(false)
        }
    }
    
    func testStartSectionDate(){
        XCUIDevice.shared().orientation = .portrait
        
        let tablesQuery = app.tables
        let cellsQuery = app.collectionViews.cells
        let poElement = cellsQuery.otherElements.containing(.staticText, identifier:"PO").element
        let f4Element = cellsQuery.otherElements.containing(.staticText, identifier:"F4").element
        let rsElement = cellsQuery.otherElements.containing(.staticText, identifier:"RS").element
        rsElement.tap()
        if tablesQuery.staticTexts["12.10.2016"].exists {
            poElement.tap()
            if tablesQuery.staticTexts["18.04.2017"].exists {
                f4Element.tap()
                if tablesQuery.staticTexts["19.05.2017"].exists {
                    XCTAssertTrue(true)
                }
                else{
                    XCTAssertTrue(false)
                }
            }
            else{
                XCTAssertTrue(false)
            }
        }
        else{
            XCTAssertTrue(false)
        }
    }
    
}
