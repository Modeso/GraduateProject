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

protocol GamesDataServiceDelegate {
    func updateData(_ table: Results<Game>)
}

class GamesDataService {
    
    enum GameDataRequestType: String {
        case schedule = "schedules"
        case results = "results"
    }
    
    var delegate: GamesDataServiceDelegate?
    
    fileprivate var games: Dictionary<Int, Game> = [:]
    
    fileprivate var isUpdating = false
    
    func getGamesTable() -> Results<Game> {
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

fileprivate extension GamesDataService {
    
    func getSchedule() {
        games.removeAll()
   //     LeaguesCommenObjects.baseUrl = LeaguesCommenObjects.BaseUrlType.normal.rawValue
        let parameters = [ "seasoncode" : LeaguesCommenObjects.season.getSeasonCode()]
        ApiClient
            .getRequestFrom(
                url:GameDataRequestType.schedule.rawValue,
                parameters: parameters,
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
   //     LeaguesCommenObjects.baseUrl = LeaguesCommenObjects.BaseUrlType.normal.rawValue
        let parameters = [ "seasoncode" : LeaguesCommenObjects.season.getSeasonCode()]
        ApiClient
            .getRequestFrom(
                url: GameDataRequestType.results.rawValue,
                parameters: parameters,
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        self?.setResults(xmlData)
                        let table = RealmDBManager.sharedInstance.getGames()
                        self?.games.removeAll()
                        for game in table {
                            let gameData = game.clone()
                            self?.games[game.gameNumber] = gameData
                        }
                        self?.delegate?.updateData(RealmDBManager.sharedInstance.getGames())
                        self?.isUpdating = false
                    }
        }
    }
    
    func parseSchedule(_ xmlData: Data){
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["schedule"]["item"].all {
            let game = Game()
            game.parseGameData(elem)
            
            RealmDBManager.sharedInstance.addGameDataToRealm(game: game)
            games[game.gameNumber] = game
        }
    }
    
    func setResults(_ xmlData: Data){
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["results"]["game"].all{
            do{
                let gameNumber: Int = try elem["gamenumber"].value()
                if let played = games[gameNumber]?.played,
                    played {
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

