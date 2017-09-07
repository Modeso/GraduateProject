//
//  RoundMatchesViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/7/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import EuroLeagueKit

class RoundsMatchesViewModel {

    fileprivate var rounds: [LeagueRound]

    fileprivate var allRoundsMatches: [String: [[Game]]] = [:]

    fileprivate var lastPlayedGame: [String : (section: Int, row: Int)] = [:]

    init(season: Constants.Season) {
        rounds = season.getRounds()
    }

    func makeRoundsMatches(from schedule: [Game]) {
        for round in rounds {
            allRoundsMatches[round.name] = makingTableDataOf(round: round.name, schedule: schedule)
        }
    }

    func getGames(of round: String) -> [[Game]]? {
        return allRoundsMatches[round]
    }

    func getLastGame(of round: String) -> (section: Int, row: Int)? {
        return lastPlayedGame[round]
    }

}

fileprivate extension RoundsMatchesViewModel {

    func makingTableDataOf(round: String, schedule: [Game]) -> [[Game]] {
        var section = 0
        var row = 0
        var gamesTable = [[Game]]()
        var gameSection = [Game]()
        var prevSectionDate: Date? = nil
        for game in schedule where game.round == round {
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
        if gameSection.count > 0 {
            gamesTable.append(gameSection)
        }
        return gamesTable
    }

}
