//
//  TurkishAirLinesHelper.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/19/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import SWXMLHash
import RealmSwift

class TurkishAirLinesHelper {
    
    enum GameDataStatus {
        case schedule
        case results
    }
    
    //In viewModel has array of games according to target round
    var table: Dictionary<String, [Array<GameData>]> = [:]
    
    private var games: Dictionary<Int, GameData> = [:] {
        didSet{
            //Notify the view Model
        }
    }
    
    //In viewModel has target round
    private var round: String = ""
    
    let urls: Dictionary<GameDataStatus, String> = [
        .schedule : "http://www.euroleague.net/euroleague/api/schedules?seasoncode=E2016",
        .results : "http://www.euroleague.net/euroleague/api/results?seasoncode=E2016"
    ]
    
    //Should have no parameters and return table of dataBase
    func getGamesTable(round: String) {
        games.removeAll()
        let table = RealmDBManager.sharedInstance.getDataFromRealm()
        print("Data is here")
        print("table count: \(table.count)")
        for game in table {
            let gameData = GameData()
            gameData.awayScore = game.awayScore
            gameData.awayTv = game.awayTv
            gameData.date = game.date
            gameData.gameNumber = game.gameNumber
            gameData.homeScore = game.homeScore
            gameData.homeTv = game.homeTv
            gameData.played = game.played
            gameData.round = game.round
            gameData.time = game.time
            games[game.gameNumber] = gameData
        }
        print("Games count: \(games.count)")
        self.round = round
        getSchedule()
    }
    
    //Api Client calling functions
    
    private func getSchedule() {
        print("getting Schedule")
        TurkishAirlinesApiClient
            .getRequestFrom(
                url: urls[.schedule]!,
                parameters: [:],
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        self?.parseSchedule(xmlData)
                        self?.getResults()
                    }
                    else {
                        print("error in schedule data")
                    }
        }
    }
    
    private func getResults() {
        print("getting Results")
        TurkishAirlinesApiClient
            .getRequestFrom(
                url: urls[.results]!,
                parameters: [:],
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        self?.setResults(xmlData)
                        let table = RealmDBManager.sharedInstance.getDataFromRealm()
                        self?.games.removeAll()
                        print("Data is here")
                        print("table count: \(table.count)")
                        ///
                        print("Data is here")
                        print("table count: \(table.count)")
                        for game in table {
                            let gameData = GameData()
                            gameData.awayScore = game.awayScore
                            gameData.awayTv = game.awayTv
                            gameData.date = game.date
                            gameData.gameNumber = game.gameNumber
                            gameData.homeScore = game.homeScore
                            gameData.homeTv = game.homeTv
                            gameData.played = game.played
                            gameData.round = game.round
                            gameData.time = game.time
                            self?.games[game.gameNumber] = gameData
                        }
                        print("Games count: \(self?.games.count)")
                    }
                    else{
                        print("error in results data")
                    }
        }
    }
    
    private func makingTableData() {
        var gamesTable = [Array<GameData>]()
        var gameSection = Array<GameData>()
        var prevSectionDate: Date? = nil
        for game in games {
            if game.value.round == round {
                if prevSectionDate == nil {
                    prevSectionDate = game.value.date
                } else if prevSectionDate != game.value.date {
                    gamesTable.append(gameSection)
                    gameSection.removeAll()
                    prevSectionDate = game.value.date
                }
                gameSection.insert(game.value, at: 0)
            }
        }
        table[round] = gamesTable
    }
    
    private func parseSchedule(_ xmlData: Data){
        print("Parsing schedule")
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["schedule"]["item"].all {
            let game = GameData()
            do{
                game.round = try elem["round"].value()
                game.date = convertDate(date: try elem["date"].value())
                game.time = try elem["startime"].value()
                game.gameNumber = try elem["game"].value()
                game.homeTv = try elem["hometv"].value()
                game.awayTv = try elem["awaytv"].value()
                game.played = try elem["played"].value()
                RealmDBManager.sharedInstance.addDataToRealm(game: game)
                games[game.gameNumber] = game
            }
            catch {
                print("error in parsing the schedule!!")
                print(error)
            }
        }
    }
    
    private func setResults(_ xmlData: Data){
        print("Setting Results")
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["results"]["game"].all{
            do{
                let gameNumber: Int = try elem["gamenumber"].value()
                if (games[gameNumber]?.played)! {
                    RealmDBManager
                        .sharedInstance
                        .updateScoreFor(games[gameNumber]!,
                                        homeScore: try elem["homescore"].value(),
                                        awayScore: try elem["awayscore"].value())
                }
            } catch {
                print("error in setting the results!!")
                print(error)
            }
        }
    }
    
    private func convertDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: date)!
    }
    
    
}

