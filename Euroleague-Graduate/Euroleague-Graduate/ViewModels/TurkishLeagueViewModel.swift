//
//  TurkishLeagueViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

protocol GameDataViewModelDelegate {
    func updateControllersData(_ table: Dictionary<String, [Array<GameData>]>,
                               lastPlayedGames: Dictionary<String, (section: Int, row: Int)>)
}

class TurkishLeagueViewModel {
    
    private let rounds: Array<String> = [
        "RS", "PO", "FF"
    ]
    
    private let helper: TurkishAirLinesGamesDataService
        
    var delegate: GameDataViewModelDelegate?
    
    fileprivate var schedule: Results<GameData>? {
        didSet {
            if schedule != nil {
                for round in rounds {
                    makingTableDataOf(round)
                }
                delegate?.updateControllersData(table, lastPlayedGames: lastPlayedGame)
            }
        }
    }
    
    fileprivate var lastPlayedGame: Dictionary<String, (section: Int, row: Int)> = [:]
    
    fileprivate var table: Dictionary<String, [Array<GameData>]> = [:]
    
    init() {
        helper = TurkishAirLinesGamesDataService()
    }
    
    func getData(){
        helper.delegate = self
        schedule = helper.getGamesTable()
        helper.updateData()
    }
    
    func updateData() {
        helper.updateData()
    }
    
}

extension TurkishLeagueViewModel: TurkishAirLinesGamesDataServiceDelegate {
    
    func updateData(_ table: Results<GameData>){
        schedule = table
    }
    
}

fileprivate extension TurkishLeagueViewModel {
    
    func makingTableDataOf(_ round: String) {
        var section = 0
        var row = 0
        var gamesTable = [Array<GameData>]()
        var gameSection = Array<GameData>()
        var prevSectionDate: Date? = nil
        for game in schedule! {
            let newGame = game.cloneGame()
            if newGame.round == round {
                if prevSectionDate == nil {
                    prevSectionDate = newGame.date
                    lastPlayedGame[round] = (section, row)
                } else if prevSectionDate != newGame.date {
                    gamesTable.append(gameSection)
                    gameSection.removeAll()
                    section += 1
                    row = 0
                    prevSectionDate = newGame.date
                }
                gameSection.append(newGame)
                if newGame.played {
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
