//
//  TurkishAirLinesHelper.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/19/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import SWXMLHash

class TurkishAirLinesHelper {
    
    enum GameDataStatus {
        case schedule
        case results
    }
    //In viewModel
    var table: Dictionary<String, [Array<GameData>]> = [:]
    
    private var games: Dictionary<Int, GameData> = [:]
    
    //In viewModel
    private var round: String = ""
    
    let urls: Dictionary<GameDataStatus, String> = [
        .schedule : "http://www.euroleague.net/euroleague/api/schedules?seasoncode=E2016",
        .results : "http://www.euroleague.net/euroleague/api/results?seasoncode=E2016"
    ]
    
    func getGamesTable(round: String) {
        self.round = round
        if games.count == 0 {
            getSchedule()
        }
    }
    
    private func getSchedule() {
        print("gettng Schedule")
        TurkishAirlinesApiClient
            .getRequestFrom(
                url: urls[.schedule]!,
                parameters: [:],
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        self?.parseSchedule(xmlData)
                        self?.getResults()
                    }
                    else{
                        print("error in schedule data")
                    }
        }
    }
    
    private func getResults() {
        TurkishAirlinesApiClient
            .getRequestFrom(
                url: urls[.results]!,
                parameters: [:],
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        self?.setResults(xmlData)
                        //self?.makingTableData()
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
                games[game.gameNumber] = game
            }
            catch {
                print("error in parsing the schedule!!")
                print(error)
            }
        }
    }
    
    private func convertDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: date)!
    }
    
    private func setResults(_ xmlData: Data){
        print("Setting Results")
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["results"]["game"].all{
            do{
                let gameNumber: Int = try elem["gamenumber"].value()
                if (games[gameNumber]?.played)! {
                    games[gameNumber]?.homeScore = try elem["homescore"].value()
                    games[gameNumber]?.awayScore = try elem["awayscore"].value()
                }
            } catch {
                print("error in parsing the schedule!!")
                print(error)
            }
        }
    }
    
}

