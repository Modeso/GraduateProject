//
//  TurkishLeagueTeamsViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import EuroLeagueKit

class TeamsViewModel: AbstractViewModel {

    fileprivate let teamDataService: TeamsDataService

    init(season: Constants.Season) {
        teamDataService = TeamsDataService(season: season)
    }

    func getData(withData: [Any]?, completion: @escaping ([NSArray]?) -> Void) {
        getTeamsData(completion: completion)
    }

}

fileprivate extension TeamsViewModel {

    func getTeamsData(completion: @escaping ([NSArray]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.teamDataService.getTeamsTable() { (clubs) in
                if let clubsData = clubs {
                    let teams = self?.makeTeams(from: clubsData)
                    DispatchQueue.main.async {
                        completion(teams as [NSArray]?)
                    }

                } else {
                        completion(nil)
                }
            }
        }
    }

    func makeTeams(from clubs: [Team]) -> Array<[Team]> {
        var teams = Array<[Team]>()
        var teamSection = Array<Team>()
        var firstChar: Character? = nil
        for club in clubs {
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
        return teams
    }
}
