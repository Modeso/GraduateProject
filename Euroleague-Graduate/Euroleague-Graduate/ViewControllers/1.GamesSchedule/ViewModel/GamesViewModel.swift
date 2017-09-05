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

    private var rounds: [(round: String, name: String, completeName: String)]
    fileprivate let gameDataService: GamesDataService
    fileprivate let teamDataService: TeamsDataService

    fileprivate var teams: Dictionary<String, Team> = [:]

    fileprivate var lastPlayedGame: Dictionary<String, (section: Int, row: Int)> = [:]

    init(season: Constants.Season) {
        rounds = season.getRounds()
        gameDataService = GamesDataService(season: season)
        teamDataService = TeamsDataService(season: season)
    }

    func getData(withData data: [Any]?, completion: @escaping ([NSArray]?) -> Void) {
        if let round = data?[0] as? String {
            getGamesData(ofRound: round, completion: completion)
        }
    }

    func getLastGame(round: String) -> (section: Int, row: Int)? {
        return lastPlayedGame[round]
    }

    func updateData(withData round: String, completion: @escaping ([NSArray]?) -> Void) {
        updateGames(ofRound: round, completion: completion)
    }
}

fileprivate extension GamesViewModel {

    //For games
    func getGamesData(ofRound round: String, completion: @escaping ([NSArray]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.teamDataService.getTeamsTable() { [weak self] clubs in
                DispatchQueue.global().async { [weak self] in
                    if let clubsData = clubs {
                        self?.makeTeamsOf(clubsData)
                        self?.gameDataService.getGamesTable() { [weak self] gameArray in
                            DispatchQueue.global().async { [weak self] in
                                if let games = gameArray {
                                    let table = self?.makingTableDataOf(round, schedule: games)
                                    DispatchQueue.main.async {
                                        completion(table as [NSArray]?)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        completion(nil)
                                    }
                                }
                            }
                        }
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }

    func updateGames(ofRound round: String, completion: @escaping ([NSArray]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.gameDataService.updateData() { [weak self] gameArray in
                DispatchQueue.global().async { [weak self] in
                    if let games = gameArray {
                        let table = self?.makingTableDataOf(round, schedule: games)
                        DispatchQueue.main.async {
                            completion(table as [NSArray]?)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

    func makingTableDataOf(_ round: String, schedule: [Game]) -> [Array<Game>] {
        var section = 0
        var row = 0
        var gamesTable = [Array<Game>]()
        var gameSection = Array<Game>()
        var prevSectionDate: Date? = nil
        for game in schedule {
            let game = game.clone()
            if game.round == round {
                if let homeUrl = teams[game.homeCode]?.logoUrl,
                    let awayUrl = teams[game.awayCode]?.logoUrl {
                    game.awayImageUrl = awayUrl
                    game.homeImageUrl = homeUrl
                }
                if prevSectionDate == nil {
                    prevSectionDate = game.date
                    lastPlayedGame[round] = (section, row)
                } else if prevSectionDate != game.date {
                    gamesTable.append(gameSection)
                    gameSection.removeAll()
                    section += 1
                    row = 0
                    prevSectionDate = game.date
                }
                gameSection.append(game)
                if game.played {
                    lastPlayedGame[round] = (section, row)
                }
                row += 1
            }
        }
        if gameSection.count > 0 {
            gamesTable.append(gameSection)
        }
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
