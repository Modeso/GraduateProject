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

protocol TurkishAirLinesTeamsDataServiceDelegate {
    func updateData(_ table: Results<Team>)
}

class TurkishAirLinesTeamsDataService {
    
    fileprivate let url = "teams?seasoncode=E2016"
    
    var delegate: TurkishAirLinesTeamsDataServiceDelegate?
    
    ///Will return the teams data from DataBase
    func getTeamsTable() -> Results<Team>{
        return RealmDBManager.sharedInstance.getTeams()
    }
    
    func updateTeams() {
        getTeams()
    }
}

fileprivate extension TurkishAirLinesTeamsDataService {
    
    func getTeams() {
        ApiClient.getRequestFrom(url: url,
                                 parameters: [:],
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
