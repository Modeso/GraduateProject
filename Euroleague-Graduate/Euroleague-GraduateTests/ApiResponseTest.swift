//
//  ApiResponseTest.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/19/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import XCTest
@testable import Euroleague_Graduate

class ApiResponseTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGetScheduleFromApi(){
        let expectation = self.expectation(description: "getting schedule")
        TurkishAirlinesApiClient
            .getRequestFrom(url: "http://www.euroleague.net/euroleague/api/schedules?seasoncode=E2016",
                            parameters: [:],
                            headers: [:]) { data, error in
                                XCTAssertNotNil(data)
                                XCTAssertNil(error)
                                expectation.fulfill()
        
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetResultsFromApi(){
        let expectation = self.expectation(description: "getting schedule")
        TurkishAirlinesApiClient
            .getRequestFrom(url: "http://www.euroleague.net/euroleague/api/results?seasoncode=E2016",
                            parameters: [:],
                            headers: [:]) { data, error in
                                XCTAssertNotNil(data)
                                XCTAssertNil(error)
                                expectation.fulfill()
                                
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
