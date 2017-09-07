//
//  TurkishLeagueViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import EuroLeagueKit

class GamesViewModel: AbstractViewModel {

    fileprivate let gameDataService: GamesDataService
    fileprivate let teamDataService: TeamsDataService

    fileprivate var teams: [String : Team] = [:]

    init(season: Constants.Season) {
        gameDataService = GamesDataService(season: season)
        teamDataService = TeamsDataService(season: season)
    }

    func getData(withData data: [Any]?, completion: @escaping ([Any]?) -> Void) {
        getGamesData(completion: completion)
    }

    func updateData(withData round: String, completion: @escaping ([Any]?) -> Void) {
        updateGames(ofRound: round, completion: completion)
    }
}

fileprivate extension GamesViewModel {

    //For games
    func getGamesData(completion: @escaping ([Any]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.teamDataService.getTeamsTable { [weak self] clubs in
                if let clubsData = clubs {
                    self?.makeTeamsOf(clubsData)
                    self?.gameDataService.getGamesTable { [weak self] gameArray in
                        if let games = gameArray {
                            let table = self?.makingTableDataOf(schedule: games)
                            DispatchQueue.main.async {
                                completion(table as [Any]?)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(nil)
                            }
                        }
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }

    func updateGames(ofRound round: String, completion: @escaping ([Any]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.gameDataService.updateData { [weak self] gameArray in
                if let games = gameArray {
                    let table = self?.makingTableDataOf(schedule: games)
                    DispatchQueue.main.async {
                        completion(table as [Any]?)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }

    func makingTableDataOf(schedule: [Game]) -> [Game] {
        //        var section = 0
        //        var row = 0
        var gamesTable = [Game]()
        //        var gameSection = [Game]()
        //        var prevSectionDate: Date? = nil
        for game in schedule {
            if let homeUrl = teams[game.homeCode]?.logoUrl,
                let awayUrl = teams[game.awayCode]?.logoUrl {
                game.awayImageUrl = awayUrl
                game.homeImageUrl = homeUrl
            }
            gamesTable.append(game)
            //            let game = game.clone()
            //            if game.round == round {
            //                if let homeUrl = teams[game.homeCode]?.logoUrl,
            //                    let awayUrl = teams[game.awayCode]?.logoUrl {
            //                    game.awayImageUrl = awayUrl
            //                    game.homeImageUrl = homeUrl
            //                }
            //                if prevSectionDate == nil {
            //                    prevSectionDate = game.date
            //                    lastPlayedGame[round] = (section, row)
            //                } else if prevSectionDate != game.date {
            //                    gamesTable.append(gameSection)
            //                    gameSection.removeAll()
            //                    section += 1
            //                    row = 0
            //                    prevSectionDate = game.date
            //                }
            //                gameSection.append(game)
            //                if game.played {
            //                    lastPlayedGame[round] = (section, row)
            //                }
            //                row += 1
            //            }
        }
        //        if gameSection.count > 0 {
        //            gamesTable.append(gameSection)
        //        }
        return gamesTable
    }

    //For Teams
    func makeTeamsOf(_ table: [Team]) {
        for team in table {
            let club = team.clone()
            teams[club.code] = club
        }
    }

}
