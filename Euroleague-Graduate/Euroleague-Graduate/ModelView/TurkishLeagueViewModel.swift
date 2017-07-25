//
//  TurkishLeagueViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

protocol <#name#> {
    <#requirements#>
}

class TurkishLeagueViewModel: TurkishAirlinesHelperDelegate {
    
    private let helper: TurkishAirLinesHelper
    
    private var registeredControllers:Array<UITableViewController> = []
    
    private var schedule: Results<GameData> {
        didSet {
            // notify the controllers that data is ready
        }
    }
    
    private var table: Dictionary<String, [Array<GameData>]> = [:]
    
    init() {
        helper = TurkishAirLinesHelper()
        schedule = helper.getGamesTable()
    }
    
    func getDataOfRound(_ round: String) -> [Array<GameData>]? {
        helper.setMyDelegate(turkishViewModel: self)
        makingTableDataOf(round)
        return table[round]
    }
    
    private func makingTableDataOf(_ round: String) {
        var gamesTable = [Array<GameData>]()
        var gameSection = Array<GameData>()
        var prevSectionDate: Date? = nil
        for game in schedule {
            let newGame = getGameDataSet(game)
            if newGame.round == round {
                if prevSectionDate == nil {
                    prevSectionDate = newGame.date
                } else if prevSectionDate != newGame.date {
                    gamesTable.append(gameSection)
                    gameSection.removeAll()
                    prevSectionDate = newGame.date
                }
                gameSection.append(getGameDataSet(newGame))
            }
        }
        if gameSection.count > 0 {
            gamesTable.append(gameSection)
        }
        table[round] = gamesTable
    }
    
    private func getGameDataSet(_ game: GameData) -> GameData {
        let newGame = GameData()
        newGame.awayScore = game.awayScore
        newGame.awayTv = game.awayTv
        newGame.date = game.date
        newGame.gameNumber = game.gameNumber
        newGame.homeScore = game.homeScore
        newGame.homeTv = game.homeTv
        newGame.played = game.played
        newGame.round = game.round
        newGame.time = game.time
        return newGame
    }
    
    func updateData(_ table: Results<GameData>){
        schedule = table
    }
}
