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
    
    func testAllGamesAreRetrieved() {
        XCTAssertEqual(schedule?.count, 3, "the schedule count was \(schedule?.count) not 3")
    }
    
    func testAllGamesInRoundsRetrieved(){
        var rsCount = 0
        var poCount = 0
        var ffCount = 0
        for games in (schedule?["RS"])! {
            rsCount += games.count
        }
        XCTAssertEqual(rsCount, 240)
        
        for games in (schedule?["PO"])! {
                poCount += games.count
        }
        XCTAssertEqual(poCount, 15)
        
        for games in (schedule?["FF"])! {
                ffCount += games.count
        }
        XCTAssertEqual(ffCount, 4)
    }
    
    func testStartAndEndGamesOfRSAreSortedAndCorrect() {
        let startGame = schedule?["RS"]?[0][0]
        XCTAssertEqual(startGame?.awayScore, 65)
        XCTAssertEqual(startGame?.awayTv, "OLY")
        XCTAssertEqual(startGame?.date, Date().convertStringToDate(date: "Oct 12, 2016"))
        XCTAssertEqual(startGame?.gameNumber, 4)
        XCTAssertEqual(startGame?.homeScore, 83)
        XCTAssertEqual(startGame?.homeTv, "RMB")
        XCTAssertEqual(startGame?.played, true)
        XCTAssertEqual(startGame?.time, "21:00")
        
        let section = (schedule?["RS"]?.count)! - 1
        let row = (schedule?["RS"]?[section].count)! - 1
        let endGame = schedule?["RS"]?[section][row]
        XCTAssertEqual(endGame?.awayScore, 80)
        XCTAssertEqual(endGame?.awayTv, "EFS")
        XCTAssertEqual(endGame?.date, Date().convertStringToDate(date: "Apr 07, 2017"))
        XCTAssertEqual(endGame?.gameNumber, 240)
        XCTAssertEqual(endGame?.homeScore, 97)
        XCTAssertEqual(endGame?.homeTv, "RMB")
        XCTAssertEqual(endGame?.played, true)
        XCTAssertEqual(endGame?.time, "21:00")
        
    }
    
    func testStartAndEndGamesOfPOAreSortedAndCorrect() {
        
        let startGame = schedule?["PO"]?[0][0]
        XCTAssertEqual(startGame?.awayScore, 90)
        XCTAssertEqual(startGame?.awayTv, "BKN")
        XCTAssertEqual(startGame?.date, Date().convertStringToDate(date: "Apr 18, 2017"))
        XCTAssertEqual(startGame?.gameNumber, 244)
        XCTAssertEqual(startGame?.homeScore, 98)
        XCTAssertEqual(startGame?.homeTv, "CSK")
        XCTAssertEqual(startGame?.played, true)
        XCTAssertEqual(startGame?.time, "19:00")
        
        let section = (schedule?["PO"]?.count)! - 1
        let row = (schedule?["PO"]?[section].count)! - 1
        let endGame = schedule?["PO"]?[section][row]
        XCTAssertEqual(endGame?.awayScore, 78)
        XCTAssertEqual(endGame?.awayTv, "EFS")
        XCTAssertEqual(endGame?.date, Date().convertStringToDate(date: "May 02, 2017"))
        XCTAssertEqual(endGame?.gameNumber, 259)
        XCTAssertEqual(endGame?.homeScore, 87)
        XCTAssertEqual(endGame?.homeTv, "OLY")
        XCTAssertEqual(endGame?.played, true)
        XCTAssertEqual(endGame?.time, "20:00")
        
    }
    
    func testStartAndEndGamesOfF4AreSortedAndCorrect() {
        
        let startGame = schedule?["FF"]?[0][0]
        XCTAssertEqual(startGame?.awayScore, 82)
        XCTAssertEqual(startGame?.awayTv, "OLY")
        XCTAssertEqual(startGame?.date, Date().convertStringToDate(date: "May 19, 2017"))
        XCTAssertEqual(startGame?.gameNumber, 261)
        XCTAssertEqual(startGame?.homeScore, 78)
        XCTAssertEqual(startGame?.homeTv, "CSK")
        XCTAssertEqual(startGame?.played, true)
        XCTAssertEqual(startGame?.time, "17:30")
        
        let section = (schedule?["FF"]?.count)! - 1
        let row = (schedule?["FF"]?[section].count)! - 1
        let endGame = schedule?["FF"]?[section][row]
        XCTAssertEqual(endGame?.awayScore, 64)
        XCTAssertEqual(endGame?.awayTv, "OLY")
        XCTAssertEqual(endGame?.date, Date().convertStringToDate(date: "May 21, 2017"))
        XCTAssertEqual(endGame?.gameNumber, 263)
        XCTAssertEqual(endGame?.homeScore, 80)
        XCTAssertEqual(endGame?.homeTv, "FNB")
        XCTAssertEqual(endGame?.played, true)
        XCTAssertEqual(endGame?.time, "20:00")
        
    }
    
    func updateControllersData(_ table: Dictionary<String, [Array<GameData>]>,
                               lastPlayedGames: Dictionary<String, (section: Int, row: Int)>) {
        schedule = table
    }
    
}
