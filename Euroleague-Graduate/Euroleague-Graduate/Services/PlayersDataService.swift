//
//  PlayersDataService.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import SWXMLHash
import RealmSwift


class PlayersDataService {
    
    func getPlayer(withCode code: String) -> Player? {
        guard let player = RealmDBManager.sharedInstance.getPlayer(withCode: code)
            else { return nil }

        return player
    }
    
    func updatePlayer(withCode code: String, completion:@escaping (_ player:Player) -> Void) {
    //    LeaguesCommenObjects.baseUrl = LeaguesCommenObjects.BaseUrlType.normal.rawValue
        let url = "players"
        let parameters = [
            "pcode" : "\(code)",
            "seasoncode" : LeaguesCommenObjects.season.getSeasonCode()
        ]
        ApiClient.getRequestFrom(url: url,
                                 parameters: parameters,
                                 headers: [:]){ [weak self] data ,error in
                                    if let xmlData = data, error == nil {
                                        self?.parsePlayerData(xmlData,code: code){ player in
                                            completion(player)
                                        }
                                    }
                                    else {
                                        ///Tell that there was an error
                                        print("error in Player data with code \(code)")
                                    }
        }

    }
    
}

fileprivate extension PlayersDataService {
    
    func parsePlayerData(_ xmlData: Data, code: String,completion: (Player)->Void) {
        let xml = SWXMLHash.parse(xmlData)
        let player = Player()
        for elem in xml["player"].all {
            player.parsePlayerData(elem)
        }
        if player.name != "" {
            player.code = code
            RealmDBManager.sharedInstance.addPlayer(player)
            completion(player)
        }
        
    }
}
