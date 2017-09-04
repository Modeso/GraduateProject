//
//  TurkishAirLinesTeamsDataService.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/31/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import SWXMLHash

protocol TeamsDataServiceDelegate: class {
    func updateData(_ table: [Team])
}

class TeamsDataService {

    fileprivate let url = "teams"

    weak var delegate: TeamsDataServiceDelegate?

    fileprivate let currentSeason: Constants.Season

    init(season: Constants.Season) {
        currentSeason = season
    }

    ///Will return the teams data from DataBase
    func getTeamsTable() {
        DispatchQueue.global().async { [weak self] in
            if let table = RealmDBManager.sharedInstance.getTeams(ofSeason: self?.currentSeason.getSeasonCode() ?? "") {
                var arrayTabel: [Team] = []
                for team in table {
                    arrayTabel.append(team.clone())
                }
                self?.delegate?.updateData(arrayTabel)
            }
            self?.updateTeams()
        }
    }

    func updateTeams() {
        getTeams()
    }

    deinit {
        print("deinit TeamsDataService")
    }

}

fileprivate extension TeamsDataService {

    func getTeams() {
        let parameters = [ "seasoncode" : currentSeason.getSeasonCode() ]
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
                                                self?.delegate?.updateData(arrayTabel)
                                            }
                                        }
                                    } else {
                                        ///Tell that there was an error
                                        print("error in Teams data")
                                    }
        }
    }

    func parseTeamData(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["clubs"]["club"].all {
            let team = Team()
            team.seasonCode = currentSeason.getSeasonCode()
            team.parseTeamData(elem)
            RealmDBManager.sharedInstance.addTeamDataToRealm(team)
        }
    }
}
