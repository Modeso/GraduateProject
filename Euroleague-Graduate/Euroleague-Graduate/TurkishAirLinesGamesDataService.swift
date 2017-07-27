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

protocol TurkishAirLinesGamesDataServiceDelegate {
    func updateData(_ table: Results<GameData>) -> Void
}

class TurkishAirLinesGamesDataService {
    
    enum GameDataType {
        case schedule
        case results
    }
    
    var delegate: TurkishAirLinesGamesDataServiceDelegate?
    
    fileprivate var games: Dictionary<Int, GameData> = [:]
    
    fileprivate var isUpdating = false
    
    
    let urls: Dictionary<GameDataType, String> = [
        .schedule : "schedules?seasoncode=E2016",
        .results : "results?seasoncode=E2016"
    ]
    
    func getGamesTable() -> Results<GameData> {
        let table = RealmDBManager.sharedInstance.getGames()
        return table
    }
    
    func updateData(){
        if !isUpdating {
            isUpdating = true
            getSchedule()
        }
    }
    
}

fileprivate extension TurkishAirLinesGamesDataService {
    
    func getSchedule() {
        print("Getting Schedule")
        games.removeAll()
        ApiClient
            .getRequestFrom(
                url: urls[.schedule]!,
                parameters: [:],
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        print("Done Getting Schedule")
                        self?.parseSchedule(xmlData)
                        self?.getResults()
                    }
                    else {
                        print("error in schedule data")
                    }
        }
    }
    
    func getResults() {
        print("Getting Results")
        ApiClient
            .getRequestFrom(
                url: urls[.results]!,
                parameters: [:],
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        self?.setResults(xmlData)
                        print("Done Setting Results")
                        let table = RealmDBManager.sharedInstance.getGames()
                        self?.games.removeAll()
                        for game in table {
                            let gameData = game.cloneGame()
                            self?.games[game.gameNumber] = gameData
                        }
                        self?.delegate?.updateData(RealmDBManager.sharedInstance.getGames())
                        self?.isUpdating = false
                        print("Done Getting Results")
                    }
        }
    }
    
    func parseSchedule(_ xmlData: Data){
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["schedule"]["item"].all {
            do{
                var game = GameData()
                game = try game.parseGameData(elem)
                RealmDBManager.sharedInstance.addDataToRealm(game: game)
                games[game.gameNumber] = game
            }
            catch {
                print("error in parsing the schedule!!")
                print(error)
            }
        }
    }
    
    func setResults(_ xmlData: Data){
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
    
}

