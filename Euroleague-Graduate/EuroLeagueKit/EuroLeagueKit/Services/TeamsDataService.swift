//
//  TeamsDataService.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/31/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import SWXMLHash

public class TeamsDataService {

    fileprivate let url = "teams"
    fileprivate let currentSeason: Constants.Season

    public init(season: Constants.Season) {
        currentSeason = season
    }

    ///Will return the teams data from DataBase
    public func getTeams(completion: @escaping ([Team]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let table = RealmDBManager.sharedInstance.getTeams(ofSeason: self?.currentSeason.getSeasonCode() ?? "") {
                var arrayTabel: [Team] = []
                for team in table {
                    arrayTabel.append(team.clone())
                }
                completion(arrayTabel)
            }
            self?.updateTeams(completion: completion)
        }
    }

}

fileprivate extension TeamsDataService {

    func updateTeams(completion: @escaping ([Team]?) -> Void) {
        getTeamsFromApi(completion: completion)
    }

    func getTeamsFromApi(completion: @escaping ([Team]?) -> Void) {
        let parameters = [ "seasoncode": currentSeason.getSeasonCode() ]
        ApiClient.getRequestFrom(url: url,
                                 parameters: parameters,
                                 headers: [:]) { [weak self] data, error in
                                    if let xmlData = data, error == nil {
                                        DispatchQueue.global().async { [weak self] in
                                            self?.parseTeamData(xmlData)
                                            if let table = RealmDBManager.sharedInstance.getTeams(ofSeason: self?.currentSeason.getSeasonCode() ?? "") {
                                                var arrayTabel: [Team] = []
                                                for team in table {
                                                    arrayTabel.append(team.clone())
                                                }
                                                completion(arrayTabel)
                                            }
                                        }
                                    } else {
                                        completion(nil)
                                        print("error in Teams data")
                                    }
        }
    }

    func parseTeamData(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["clubs"]["club"].all {
            let team = Team()
            team.seasonCode = currentSeason.getSeasonCode()
            team.parseTeamData(of: elem)
            RealmDBManager.sharedInstance.addTeamDataToRealm(team)
        }
    }
}
