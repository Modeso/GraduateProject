//
//  TurkishLeagueViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

class TurkishLeagueViewModel {
    
    private let helper: TurkishAirLinesHelper
    private var schedule: Results<GameData>
    private var table: Dictionary<String, [Array<GameData>]> = [:]
    private var round: String = ""
    
    init() {
        helper = TurkishAirLinesHelper()
        schedule = helper.getGamesTable()
    }
    
    func getDataOfRound(_ round: String) -> [Array<GameData>]? {
        
        return nil
    }
    
    private func makingTableData() {
//        var gamesTable = [Array<GameData>]()
//        var gameSection = Array<GameData>()
//        var prevSectionDate: Date? = nil
//        for game in schedule {
//            if game.value.round == round {
//                if prevSectionDate == nil {
//                    prevSectionDate = game.value.date
//                } else if prevSectionDate != game.value.date {
//                    gamesTable.append(gameSection)
//                    gameSection.removeAll()
//                    prevSectionDate = game.value.date
//                }
//                gameSection.insert(game.value, at: 0)
//            }
//        }
//        table[round] = gamesTable
    }
}
