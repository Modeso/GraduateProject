//
//  TurkishLeagueTeamsViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

protocol TeamsDataViewModelDelegate: class {
    func updateTeamsData(_ table: [Array<Team>])
}

class TeamsViewModel {
    
    fileprivate let teamDataService: TeamsDataService
    
    fileprivate var clubs: [Team]?{
        didSet {
            if clubs != nil, (clubs?.count)! > 0 {
                makeTeams()
                delegate?.updateTeamsData(teams)
            }
        }
    }
    
    fileprivate var teams: [Array<Team>] = []
    
    weak var delegate: TeamsDataViewModelDelegate?
    
    init(season: LeaguesCommenObjects.Season) {
        teamDataService = TeamsDataService(season: season)
        teamDataService.delegate = self
    }
    
    func getTeamsData() {
        
        teamDataService.getTeamsTable() {[weak self] realmTable in
            DispatchQueue.main.async {
                self?.clubs = realmTable
            }
        }
    }
    
    deinit {
        print("deinit TeamsViewModel")
    }
}

extension TeamsViewModel: TeamsDataServiceDelegate {
    
    func updateData(_ table: [Team]){
        DispatchQueue.main.async {
            self.clubs = table
        }
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
