//
//  GamesPagerViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import EuroLeagueKit

class GamesPagerViewModel {

    fileprivate let gameDataService: GamesDataService
    fileprivate let teamDataService: TeamsDataService

    fileprivate var teams: [String : Team] = [:]

    init(season: Constants.Season) {
        gameDataService = GamesDataService(season: season)
        teamDataService = TeamsDataService(season: season)
    }

    func updateData(withData round: String, completion: @escaping ([Any]?) -> Void) {
        updateGames(ofRound: round, completion: completion)
    }

}

extension GamesPagerViewModel: AbstractViewModel {

    func getData(withData data: [Any]?, completion: @escaping ([Any]?) -> Void) {
        getGamesData(completion: completion)
    }

}

fileprivate extension GamesPagerViewModel {

    //For games
    func getGamesData(completion: @escaping ([Any]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.teamDataService.getTeams { [weak self] clubs in
                if let clubsData = clubs {
                    self?.makeTeamsOf(clubsData)
                    self?.gameDataService.getGames { [weak self] gameArray in
                        if let gamesData = gameArray {
                            let games = self?.makingGamesDataOf(schedule: gamesData)
                            DispatchQueue.main.async {
                                completion(games as [Any]?)
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
                guard let gamesData = gameArray else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                let games = self?.makingGamesDataOf(schedule: gamesData)
                DispatchQueue.main.async {
                    completion(games as [Any]?)
                }
            }
        }
    }

    func makingGamesDataOf(schedule: [Game]) -> [Game] {
        var games = [Game]()
        for game in schedule {
            if let homeUrl = teams[game.homeCode]?.logoUrl,
                let awayUrl = teams[game.awayCode]?.logoUrl {
                game.awayImageUrl = awayUrl
                game.homeImageUrl = homeUrl
            }
            games.append(game)
        }
        return games
    }

    //For Teams
    func makeTeamsOf(_ clubs: [Team]) {
        for team in clubs {
            let club = team.clone()
            teams[club.code] = club
        }
    }

}
