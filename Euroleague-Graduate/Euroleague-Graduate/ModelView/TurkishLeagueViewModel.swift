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
    func updateControllersData(_ table: Dictionary<String, [Array<GameData>]>)
}

class TurkishLeagueViewModel: TurkishAirLinesGamesDataServiceDelegate {
    
    private let rounds: Array<String> = [
        "RS", "PO", "FF"
    ]
    
    private let helper: TurkishAirLinesGamesDataService
    
    private var registeredControllers:Array<UITableViewController> = []
    
    var delegate: GameDataViewModelDelegate?
    
    fileprivate var schedule: Results<GameData>? {
        didSet {
            if schedule != nil {
                for round in rounds {
                    makingTableDataOf(round)
                }
                delegate?.updateControllersData(table)
            }
        }
    }
    
    fileprivate var table: Dictionary<String, [Array<GameData>]> = [:]
    
    init() {
        helper = TurkishAirLinesGamesDataService()
    }
    
    func getData(){
        helper.delegate = self
        schedule = helper.getGamesTable()
        helper.updateData()
    }
    
    func updateData(_ table: Results<GameData>){
        schedule = table
    }
}

fileprivate extension TurkishLeagueViewModel {
    
    func makingTableDataOf(_ round: String) {
        var gamesTable = [Array<GameData>]()
        var gameSection = Array<GameData>()
        var prevSectionDate: Date? = nil
        for game in schedule! {
            let newGame = game.cloneGame()
            if newGame.round == round {
                if prevSectionDate == nil {
                    prevSectionDate = newGame.date
                } else if prevSectionDate != newGame.date {
                    gamesTable.append(gameSection)
                    gameSection.removeAll()
                    prevSectionDate = newGame.date
                }
                gameSection.append(game.cloneGame())
            }
        }
        if gameSection.count > 0 {
            gamesTable.append(gameSection)
        }
        table[round] = gamesTable
    }
    
}
