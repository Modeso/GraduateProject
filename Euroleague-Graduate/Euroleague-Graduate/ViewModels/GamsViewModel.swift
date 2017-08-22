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

class GamesViewModel {
    
    private var rounds: [(round: String, name: String)]
    fileprivate let gameDataService: GamesDataService
    fileprivate let teamDataService: TeamsDataService
    
    var gamesDelegate: GameDataViewModelDelegate?
    
    fileprivate var schedule: Results<Game>? {
        didSet {
            if schedule != nil , (schedule?.count)! > 0 {
                for round in rounds {
                    makingTableDataOf(round.round)
                }
                gamesDelegate?.updateControllersData(table, lastPlayedGames: lastPlayedGame)
            }
        }
    }
    
    fileprivate var teams: Dictionary<String, Team> = [:]
    
    fileprivate var lastPlayedGame: Dictionary<String, (section: Int, row: Int)> = [:]
    
    fileprivate var table: Dictionary<String, [Array<Game>]> = [:]
    
    init() {
        rounds = LeaguesCommenObjects.season.getRounds()
        gameDataService = GamesDataService()
        teamDataService = TeamsDataService()
        teamDataService.delegate = self
        gameDataService.delegate = self
    }
    
    func getGamesData(){
        makeTeamsOf(teamDataService.getTeamsTable())
        schedule = gameDataService.getGamesTable()
        teamDataService.updateTeams()
    }
    
    func updateData() {
        gameDataService.updateData()
    }
    
}

extension GamesViewModel: GamesDataServiceDelegate {
    
    func updateData(_ table: Results<Game>){
        schedule = table
    }
    
}

extension GamesViewModel: TeamsDataServiceDelegate {
    
    func updateData(_ table: Results<Team>){
        makeTeamsOf(table)
        gameDataService.updateData()
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
        for game in schedule! {
            let game = game.clone()
            if game.round == round {
                if let homeUrl = teams[game.homeCode]?.logoUrl,
                    let awayUrl = teams[game.awayCode]?.logoUrl{
                    game.awayImageUrl = awayUrl
                    game.homeImageUrl = homeUrl
                }
                
                if prevSectionDate == nil {
                    prevSectionDate = game.date
                    lastPlayedGame[round] = (section, row)
                }
                else if prevSectionDate != game.date {
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
    
    //For Teams
    func makeTeamsOf(_ table: Results<Team>) {
        for team in table {
            let club = team.clone()
            teams[club.code] = club
        }
    }
    
}
