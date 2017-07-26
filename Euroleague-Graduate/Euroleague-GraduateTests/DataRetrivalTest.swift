//
//  DataRetrivalTest.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/26/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import XCTest
@testable import Euroleague_Graduate

class DataRetrivalTest: XCTestCase, GameDataViewModelDelegate {
    
    private var viewModel: TurkishLeagueViewModel?
    
    private var schedule: Dictionary<String, [Array<GameData>]>?
    
    override func setUp() {
        super.setUp()
        viewModel = TurkishLeagueViewModel()
        viewModel?.delegate = self
        viewModel?.getData()
    }
    
    override func tearDown() {
        schedule?.removeAll()
        super.tearDown()
    }
    
    func allGamesAreRetrieved() {
        XCTAssertEqual(schedule?.count, 259, "the schedule count was \(schedule?.count) not 259")
    }
    
    func allGamesInRoundsRetrieved(){
        XCTAssertEqual(schedule?["RS"]?.count, 240, "the schedule count was \(schedule?["RS"]?.count) not 240")
        XCTAssertEqual(schedule?["PO"]?.count, 15, "the schedule count was \(schedule?["PO"]?.count) not 15")
        XCTAssertEqual(schedule?["FF"]?.count, 4, "the schedule count was \(schedule?["FF"]?.count) not 4")
    }
    
    func startAndEndGamesOfRSAreSortedAndCorrect() {

        XCTAssertEqual(schedule?["RS"]?[0][0].awayScore, 65)
        XCTAssertEqual(schedule?["RS"]?[0][0].awayTv, "OLY")
        XCTAssertEqual(schedule?["RS"]?[0][0].date, convertDate(date: "Oct 12, 2016"))
        XCTAssertEqual(schedule?["RS"]?[0][0].gameNumber, 4)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeScore, 83)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeTv, "RMB")
        XCTAssertEqual(schedule?["RS"]?[0][0].played, true)
        XCTAssertEqual(schedule?["RS"]?[0][0].time, "21:00")
        
        XCTAssertEqual(schedule?["RS"]?[0][0].awayScore, 80)
        XCTAssertEqual(schedule?["RS"]?[0][0].awayTv, "EFS")
        XCTAssertEqual(schedule?["RS"]?[0][0].date, convertDate(date: "Apr 07, 2017"))
        XCTAssertEqual(schedule?["RS"]?[0][0].gameNumber, 240)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeScore, 97)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeTv, "RMB")
        XCTAssertEqual(schedule?["RS"]?[0][0].played, true)
        XCTAssertEqual(schedule?["RS"]?[0][0].time, "21:00")
        
    }
    
    func startAndEndGamesOfPOAreSortedAndCorrect() {
        
        XCTAssertEqual(schedule?["RS"]?[0][0].awayScore, 90)
        XCTAssertEqual(schedule?["RS"]?[0][0].awayTv, "BKN")
        XCTAssertEqual(schedule?["RS"]?[0][0].date, convertDate(date: "Apr 18, 2016"))
        XCTAssertEqual(schedule?["RS"]?[0][0].gameNumber, 4)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeScore, 98)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeTv, "CSK")
        XCTAssertEqual(schedule?["RS"]?[0][0].played, true)
        XCTAssertEqual(schedule?["RS"]?[0][0].time, "19:00")
        
        XCTAssertEqual(schedule?["RS"]?[0][0].awayScore, 78)
        XCTAssertEqual(schedule?["RS"]?[0][0].awayTv, "EFS")
        XCTAssertEqual(schedule?["RS"]?[0][0].date, convertDate(date: "May 02, 2017"))
        XCTAssertEqual(schedule?["RS"]?[0][0].gameNumber, 259)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeScore, 87)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeTv, "OLY")
        XCTAssertEqual(schedule?["RS"]?[0][0].played, true)
        XCTAssertEqual(schedule?["RS"]?[0][0].time, "20:00")
        
    }
    
    func startAndEndGamesOfF4AreSortedAndCorrect() {
        
        XCTAssertEqual(schedule?["RS"]?[0][0].awayScore, 82)
        XCTAssertEqual(schedule?["RS"]?[0][0].awayTv, "OLY")
        XCTAssertEqual(schedule?["RS"]?[0][0].date, convertDate(date: "May 19, 2016"))
        XCTAssertEqual(schedule?["RS"]?[0][0].gameNumber, 261)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeScore, 78)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeTv, "CSK")
        XCTAssertEqual(schedule?["RS"]?[0][0].played, true)
        XCTAssertEqual(schedule?["RS"]?[0][0].time, "17:30")
        
        XCTAssertEqual(schedule?["RS"]?[0][0].awayScore, 80)
        XCTAssertEqual(schedule?["RS"]?[0][0].awayTv, "FNB")
        XCTAssertEqual(schedule?["RS"]?[0][0].date, convertDate(date: "May 21, 2017"))
        XCTAssertEqual(schedule?["RS"]?[0][0].gameNumber, 263)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeScore, 64)
        XCTAssertEqual(schedule?["RS"]?[0][0].homeTv, "OLY")
        XCTAssertEqual(schedule?["RS"]?[0][0].played, true)
        XCTAssertEqual(schedule?["RS"]?[0][0].time, "20:00")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func updateControllersData(_ table: Dictionary<String, [Array<GameData>]>) {
        schedule = table
    }
    
    private func convertDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: date)!
    }
    
}
