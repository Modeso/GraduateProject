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
    func updateControllersData(_ table: Dictionary<String, [Array<Game>]>,
                               lastPlayedGames: Dictionary<String, (section: Int, row: Int)>)
}

class TurkishLeagueViewModel {
    
    private let rounds: Array<String> = [
        "RS", "PO", "FF"
    ]
    
    fileprivate let gameDataService: TurkishAirLinesGamesDataService
    fileprivate let teamDataService: TurkishAirLinesTeamsDataService
    
    var delegate: GameDataViewModelDelegate?
    
    fileprivate var schedule: Results<Game>? {
        didSet {
            if schedule != nil , (schedule?.count)! > 0 {
                for round in rounds {
                    makingTableDataOf(round)
                }
                delegate?.updateControllersData(table, lastPlayedGames: lastPlayedGame)
            }
        }
    }
    
    fileprivate var teams: Dictionary<String, Team> = [:]
    
    fileprivate var lastPlayedGame: Dictionary<String, (section: Int, row: Int)> = [:]
    
    fileprivate var table: Dictionary<String, [Array<Game>]> = [:]
    
    init() {
        gameDataService = TurkishAirLinesGamesDataService()
        teamDataService = TurkishAirLinesTeamsDataService()
    }
    
    func getData(){
        teamDataService.delegate = self
        gameDataService.delegate = self
        makeTeamsOf(teamDataService.getTeamsTable())
    }
    
    func updateData() {
        gameDataService.updateData()
    }
    
}

extension TurkishLeagueViewModel: TurkishAirLinesGamesDataServiceDelegate {
    
    func updateData(_ table: Results<Game>){
        schedule = table
    }
    
}

extension TurkishLeagueViewModel: TurkishAirLinesTeamsDataServiceDelegate {
    
    func updateData(_ table: Results<Team>){
        makeTeamsOf(table)
        schedule = gameDataService.getGamesTable()
        gameDataService.updateData()
    }
    
}

fileprivate extension TurkishLeagueViewModel {
    
    //For games
    func makingTableDataOf(_ round: String) {
        var section = 0
        var row = 0
        var gamesTable = [Array<Game>]()
        var gameSection = Array<Game>()
        var prevSectionDate: Date? = nil
        for game in schedule! {
            let newGame = game.cloneGame()
            if newGame.round == round {
                ///newGame.awayUrl = teams[newGame.awayCode]
                ///newGame.homeUrl = teams[newGame.homeCode]
                if prevSectionDate == nil {
                    prevSectionDate = newGame.date
                    lastPlayedGame[round] = (section, row)
                }
                else if prevSectionDate != newGame.date {
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
    
    //For Teams
    func makeTeamsOf(_ table: Results<Team>) {
        for team in table {
            let club = team.cloneTeam()
            teams[club.code] = club
        }
    }
    
}
