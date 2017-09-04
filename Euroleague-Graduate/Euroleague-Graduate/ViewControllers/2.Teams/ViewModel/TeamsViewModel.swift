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

    fileprivate var clubs: [Team]? {
        didSet {
            if clubs != nil, let count = clubs?.count, count > 0 {
                makeTeams()
                DispatchQueue.main.async {
                    self.delegate?.updateTeamsData(self.teams)
                }
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
        DispatchQueue.global().async { [weak self] in
            self?.teamDataService.getTeamsTable()
        }
    }

    deinit {
        print("deinit TeamsViewModel")
    }
}

extension TeamsViewModel: TeamsDataServiceDelegate {

    func updateData(_ table: [Team]) {
        DispatchQueue.global().async { [weak self] in
            self?.clubs = table
        }
    }

}

fileprivate extension TeamsViewModel {

    func makeTeams() {
        teams.removeAll()
        var teamSection = Array<Team>()
        var firstChar: Character? = nil
        if let currentClubs = clubs {
            for club in currentClubs {
                let team = club.clone()
                if firstChar == nil {
                    firstChar = team.name.uppercased().characters.first
                } else if firstChar != team.name.uppercased().characters.first {
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
}
