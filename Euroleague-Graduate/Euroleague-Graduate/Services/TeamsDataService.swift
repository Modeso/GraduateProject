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
    
    fileprivate let currentSeason: LeaguesCommenObjects.Season
    
    init(season: LeaguesCommenObjects.Season) {
        currentSeason = season
    }
    
    ///Will return the teams data from DataBase
    func getTeamsTable(completion:@escaping ([Team])->Void){
        print("getTeams:- local get teams for \(LeaguesCommenObjects.season.getSeasonCode())")

        DispatchQueue.global().async { [weak self] in
            let table = RealmDBManager.sharedInstance.getTeams(ofSeason: self?.currentSeason.getSeasonCode() ?? "")
            var arrayTabel: [Team] = []
            for team in table {
                arrayTabel.append(team.clone())
            }
            completion(arrayTabel)
            self?.updateTeams()
        }
    }
    
    func updateTeams() {
        print("getTeams:- updateTeams for \(LeaguesCommenObjects.season.getSeasonCode())")

        getTeams()
    }
    
    deinit {
        print("deinit TeamsDataService")
    }
    
}

fileprivate extension TeamsDataService {
    
    func getTeams() {
        print("getTeams:- api get teams for \(currentSeason.getSeasonCode())")
        let parameters = [ "seasoncode" : currentSeason.getSeasonCode() ]
        ApiClient.getRequestFrom(url: url,
                                 parameters: parameters,
                                 headers: [:]){ [weak self] data ,error in
                                    if let xmlData = data, error == nil {
                                        DispatchQueue.global().async { [weak self] in
                                            self?.parseTeamData(xmlData)
                                            let teams = RealmDBManager.sharedInstance.getTeams(ofSeason: self?.currentSeason.getSeasonCode() ?? "")
                                            var arrayTabel: [Team] = []
                                            for team in teams {
                                                arrayTabel.append(team.clone())
                                            }
                                            DispatchQueue.main.async {
                                                self?.delegate?.updateData(arrayTabel)
                                            }
                                        }
                                    }
                                    else {
                                        ///Tell that there was an error
                                        print("error in Teams data")
                                    }
        }
    }
    
    func parseTeamData(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["clubs"]["club"].all {
            let team = Team()
            team.parseTeamData(elem)
            team.seasonCode = currentSeason.getSeasonCode()
            RealmDBManager.sharedInstance.addTeamDataToRealm(team)
        }
    }
}
