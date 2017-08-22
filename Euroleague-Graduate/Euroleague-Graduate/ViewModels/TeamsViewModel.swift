//
//  TurkishLeagueTeamsViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

protocol TeamsDataViewModelDelegate {
    func updateTeamsData(_ table: [Array<Team>])
}

class TeamsViewModel {
    
    fileprivate let teamDataService: TeamsDataService
    
    fileprivate var clubs: Results<Team>?{
        didSet {
            if clubs != nil, (clubs?.count)! > 0 {
                makeTeams()
                teamsDelegate?.updateTeamsData(teams)
            }
        }
    }
    
    fileprivate var teams: [Array<Team>] = []
    
    var teamsDelegate: TeamsDataViewModelDelegate?
    
    init() {
        teamDataService = TeamsDataService()
        teamDataService.delegate = self
    }
    
    func getTeamsData() {
        clubs = teamDataService.getTeamsTable()
        teamDataService.updateTeams()
    }
}

extension TeamsViewModel: TeamsDataServiceDelegate {
    
    func updateData(_ table: Results<Team>){
        clubs = table
    }
    
}

fileprivate extension TeamsViewModel {
    
    func makeTeams() {
        teams.removeAll()
        var teamSection = Array<Team>()
        var firstChar: Character? = nil
        for club in clubs! {
            let team = club.clone()
            if firstChar == nil {
                firstChar = team.name.uppercased().characters.first
            }
            else if firstChar! != team.name.uppercased().characters.first! {
                teams.append(teamSection)
                teamSection.removeAll()
                firstChar = team.name.uppercased().characters.first
            }
            teamSection.append(team)
        }
        if teamSection.count > 0 {
            teams.append(teamSection)
        }
    }
}
