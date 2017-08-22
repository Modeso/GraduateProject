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

protocol TeamsDataServiceDelegate {
    func updateData(_ table: Results<Team>)
}

class TeamsDataService {
    
    fileprivate let url = "teams"
    
    var delegate: TeamsDataServiceDelegate?
    
    ///Will return the teams data from DataBase
    func getTeamsTable() -> Results<Team>{
        return RealmDBManager.sharedInstance.getTeams()
    }
    
    func updateTeams() {
        getTeams()
    }
}

fileprivate extension TeamsDataService {
    
    func getTeams() {
    //    LeaguesCommenObjects.baseUrl = LeaguesCommenObjects.BaseUrlType.normal.rawValue
        let parameters = [ "seasoncode" : LeaguesCommenObjects.season.getSeasonCode() ]
        ApiClient.getRequestFrom(url: url,
                                 parameters: parameters,
                                 headers: [:]){ [weak self] data ,error in
                                    if let xmlData = data, error == nil {
                                        self?.parseTeamData(xmlData)
                                        self?.delegate?.updateData(RealmDBManager.sharedInstance.getTeams())
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
            RealmDBManager.sharedInstance.addTeamDataToRealm(team)
        }
    }
}
