//
//  TurkishLeagueViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

protocol GameDataViewModelDelegate: class {
    func updateControllersData(_ table: Dictionary<String, [Array<Game>]>,
                               lastPlayedGames: Dictionary<String, (section: Int, row: Int)>)
}

class GamesViewModel {

    private var rounds: [(round: String, name: String, completeName: String)]
    fileprivate let gameDataService: GamesDataService
    fileprivate let teamDataService: TeamsDataService

    weak var delegate: GameDataViewModelDelegate?

    fileprivate var schedule: [Game]? {
        didSet {
            if schedule != nil, let count = schedule?.count, count > 0 {
                for round in rounds {
                    makingTableDataOf(round.round)
                }
                DispatchQueue.main.async {
                    self.delegate?.updateControllersData(self.table, lastPlayedGames: self.lastPlayedGame)
                }
            }
        }
    }

    fileprivate var teams: Dictionary<String, Team> = [:]

    fileprivate var lastPlayedGame: Dictionary<String, (section: Int, row: Int)> = [:]

    fileprivate var table: Dictionary<String, [Array<Game>]> = [:]

    init(season: Constants.Season) {
        rounds = season.getRounds()
        gameDataService = GamesDataService(season: season)
        teamDataService = TeamsDataService(season: season)
        teamDataService.delegate = self
        gameDataService.delegate = self
    }

    func getGamesData() {
        DispatchQueue.global().async { [weak self] in
            self?.teamDataService.getTeamsTable()
        }
    }

    func updateData() {
        DispatchQueue.global().async { [weak self] in
            self?.gameDataService.updateData()
        }
    }

    deinit {
        print("deinit GamesViewModel")
    }
}

extension GamesViewModel: GamesDataServiceDelegate {

    func updateData(_ table: [Game]) {
        DispatchQueue.global().async {
            self.schedule = table
        }
    }

}

extension GamesViewModel: TeamsDataServiceDelegate {

    func updateData(_ table: [Team]) {
        DispatchQueue.global().async { [weak self] in
            self?.makeTeamsOf(table)
            self?.gameDataService.getGamesTable()
        }
    }

}

fileprivate extension GamesViewModel {

    //For games
    func makingTableDataOf(_ round: String) {
        var section = 0
        var row = 0
        var gamesTable = [Array<Game>]()
        var gameSection = Array<Game>()
        var prevSectionDate: Date? = nil
        if let gamesSchedule = schedule {
            for game in gamesSchedule {
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
            table[round] = gamesTable
        }
    }

    //For Teams
    func makeTeamsOf(_ table: [Team]) {
        for team in table {
            let club = team.clone()
            teams[club.code] = club
        }
    }

}
