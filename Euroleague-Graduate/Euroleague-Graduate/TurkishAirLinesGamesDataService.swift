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
    
    
    let urls: Dictionary<GameDataType, String> = [
        .schedule : "schedules?seasoncode=E2016",
        .results : "results?seasoncode=E2016"
    ]
    
    //Should have no parameters and return table of dataBase
    func getGamesTable() -> Results<GameData> {
        games.removeAll()
        let table = RealmDBManager.sharedInstance.getDataFromRealm()
        return table
    }
    
    func updateData(){
        getSchedule()
    }
    
}

fileprivate extension TurkishAirLinesGamesDataService {
    
    func getSchedule() {
        print("getting Schedule")
        ApiClient
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
    
    func getResults() {
        print("getting Results")
        ApiClient
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
                        let methods = CommonFunctions()
                        for game in table {
                            let gameData = methods.getGameDataSet(game)
                            self?.games[game.gameNumber] = gameData
                        }
                        self?.delegate?.updateData(RealmDBManager.sharedInstance.getDataFromRealm())
                        print("Games count: \(self?.games.count)")
                    }
                    else{
                        print("error in results data")
                    }
        }
    }
    
    func parseSchedule(_ xmlData: Data){
        print("Parsing schedule")
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

