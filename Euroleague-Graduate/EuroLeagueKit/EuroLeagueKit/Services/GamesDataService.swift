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

public class GamesDataService {

    enum GameDataRequestType: String {
        case schedule = "schedules"
        case results = "results"
    }

    fileprivate var games: [Int: Game] = [:]

    fileprivate var isUpdating = false

    fileprivate let currentSeason: Constants.Season

    public init(season: Constants.Season) {
        currentSeason = season
    }

    public func getGamesTable(completion: @escaping ([Game]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let table = RealmDBManager.sharedInstance.getGames(ofSeason: self?.currentSeason.getSeasonCode() ?? "") {
                var arrayTable: [Game] = []
                for game in table {
                    arrayTable.append(game.clone())
                }
                completion(arrayTable)
            }
            self?.updateData(completion: completion)
        }
    }

    public func updateData(completion: @escaping ([Game]?) -> Void) {
        if !isUpdating {
            isUpdating = true
            DispatchQueue.global().async { [weak self] in
                self?.getSchedule(completion: completion)
            }
        } else {
            completion(nil)
        }
    }

}

fileprivate extension GamesDataService {

    func getSchedule(completion: @escaping ([Game]?) -> Void) {
        games.removeAll()
        let parameters = [ "seasoncode": currentSeason.getSeasonCode()]
        ApiClient
            .getRequestFrom(
                url:GameDataRequestType.schedule.rawValue,
                parameters: parameters,
                headers: [:]) { [weak self] data, error in
                    if let xmlData = data, error == nil {
                        print("current thread in getSchedule is \(Thread.current)")
                        DispatchQueue.global().async { [weak self] in
                            self?.parseSchedule(xmlData)
                            self?.getResults(completion: completion)
                        }
                    } else {
                        print("error in schedule data")
                    }
        }
    }

    func getResults(completion: @escaping ([Game]?) -> Void) {
        let parameters = [ "seasoncode": currentSeason.getSeasonCode()]

        ApiClient
            .getRequestFrom(
                url: GameDataRequestType.results.rawValue,
                parameters: parameters,
                headers: [:]) { [weak self] data, error in
                    if let xmlData = data, error == nil {
                        print("current thread in getResult is \(Thread.current)")
                        DispatchQueue.global().async { [weak self] in
                            self?.setResults(xmlData)
                            if let table = RealmDBManager.sharedInstance.getGames(ofSeason: self?.currentSeason.getSeasonCode() ?? "") {
                                var arrayTable: [Game] =  []
                                self?.games.removeAll()
                                for game in table {
                                    let gameData = game.clone()
                                    self?.games[game.gameNumber] = gameData
                                    arrayTable.append(gameData)
                                }
                                completion(arrayTable)
                            }
                            self?.isUpdating = false

                        }
                    } else {
                        self?.isUpdating = false
                        completion(nil)
                    }
        }
    }

    func parseSchedule(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["schedule"]["item"].all {
            let game = Game()
            game.parseGameData(elem)
            game.seasonCode = currentSeason.getSeasonCode()
            RealmDBManager.sharedInstance.addGameDataToRealm(game: game)
            games[game.gameNumber] = game.clone()
        }
    }

    func setResults(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["results"]["game"].all {
            do {
                let gameNumber: Int = try elem["gamenumber"].value()
                if let played = self.games[gameNumber]?.played,
                    let currentGame = self.games[gameNumber],
                    played {
                    RealmDBManager
                        .sharedInstance
                        .updateScoreFor(currentGame,
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
