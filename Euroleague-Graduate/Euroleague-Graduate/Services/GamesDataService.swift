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

protocol GamesDataServiceDelegate: class {
    func updateData(_ table: [Game])
}

class GamesDataService {

    enum GameDataRequestType: String {
        case Schedule = "schedules"
        case Results = "results"
    }

    weak var delegate: GamesDataServiceDelegate?

    fileprivate var games: Dictionary<Int, Game> = [:]

    fileprivate var isUpdating = false

    fileprivate let currentSeason: Constants.Season

    init(season: Constants.Season) {
        currentSeason = season
    }

    func getGamesTable() {
        DispatchQueue.global().async { [weak self] in
            if let table = RealmDBManager.sharedInstance.getGames(ofSeason: self?.currentSeason.getSeasonCode() ?? "") {
                var arrayTable: [Game] = []
                for game in table {
                    arrayTable.append(game.clone())
                }
                self?.delegate?.updateData(arrayTable)
            }
            self?.updateData()
        }
    }

    func updateData() {
        if !isUpdating {
            isUpdating = true
            DispatchQueue.global().async { [weak self] in
                self?.getSchedule()
            }
        }
    }

    deinit {
        print("deinit GamesDataService")
    }
}

fileprivate extension GamesDataService {

    func getSchedule() {
        games.removeAll()
        let parameters = [ "seasoncode" : currentSeason.getSeasonCode()]
        ApiClient
            .getRequestFrom(
                url:GameDataRequestType.Schedule.rawValue,
                parameters: parameters,
                headers: [:]) { [weak self] data, error in
                    if let xmlData = data, error == nil {
                        DispatchQueue.global().async { [weak self] in
                            self?.parseSchedule(xmlData)
                            self?.getResults()
                        }
                    } else {
                        print("error in schedule data")
                    }
        }
    }

    func getResults() {
        let parameters = [ "seasoncode" : currentSeason.getSeasonCode()]
        ApiClient
            .getRequestFrom(
                url: GameDataRequestType.Results.rawValue,
                parameters: parameters,
                headers: [:]) { [weak self] data, error in
                    if let xmlData = data, error == nil {
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
                                self?.delegate?.updateData(arrayTable)
                            }
                            self?.isUpdating = false
                        }
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
