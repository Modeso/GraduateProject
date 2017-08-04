//
//  PlayersDataService.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import SWXMLHash

class TurkishLeaguePlayersDataService {
    
    func getPlayer(withCode code: String) -> Player? {
        guard let player = RealmDBManager.sharedInstance.getPlayer(withCode: code)
            else { return nil }
        
        return player
    }
    
    func updatePlayer(withCode code: String) {
        let url = "players?pcode=\(code)&seasoncode=E2016"
        ApiClient.getRequestFrom(url: url,
                                 parameters: [:],
                                 headers: [:]){ [weak self] data ,error in
                                    if let xmlData = data, error == nil {
                                                                            }
                                    else {
                                        ///Tell that there was an error
                                        print("error in Player data with code \(code)")
                                    }
        }

    }
    
}

fileprivate extension TurkishLeaguePlayersDataService {
    
    func parsePlayerData(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        for elem in xml["Player"].all {
            let player = Player()
            //parse data and add it to dataBase
            
        }
    }
}
