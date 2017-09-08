//
//  MatchesTableViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/7/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import EuroLeagueKit

class MatchesTableViewModel {

    fileprivate var roundsMatches: [[Game]] = []
    fileprivate var lastPlayedGame: (section: Int, row: Int) = (0, 0)

    func getGames(from schedule: [Game]) -> [[Game]]? {
        return makingGamesDataOf(schedule: schedule)
    }

    func getLastGame() -> (section: Int, row: Int) {
        return lastPlayedGame
    }

}

fileprivate extension MatchesTableViewModel {

    func makingGamesDataOf(schedule: [Game]) -> [[Game]] {
        var section = 0
        var row = 0
        var games = [[Game]]()
        var gameSection = [Game]()
        var prevSectionDate: Date? = nil
        for game in schedule {
            if prevSectionDate == nil {
                prevSectionDate = game.date
                lastPlayedGame = (section, row)
            } else if prevSectionDate != game.date {
                games.append(gameSection)
                gameSection.removeAll()
                section += 1
                row = 0
                prevSectionDate = game.date
            }
            gameSection.append(game)
            if game.played {
                lastPlayedGame = (section, row)
            }
            row += 1
        }
        if gameSection.count > 0 {
            games.append(gameSection)
        }
        return games
    }

}
