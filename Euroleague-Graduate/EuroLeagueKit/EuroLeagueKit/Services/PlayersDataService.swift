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


public class PlayersDataService {

    fileprivate let currentSeason: Constants.Season

    public init(season: Constants.Season) {
        currentSeason = season
    }

    public func getPlayer(withCode code: String, completion: @escaping (Player?) -> Void) {
        DispatchQueue.global().async {
            let player = RealmDBManager.sharedInstance.getPlayer(withCode: code)
            completion(player?.clone())
            self.updatePlayer(withCode: code, completion: completion)
        }
    }

}

fileprivate extension PlayersDataService {

    func updatePlayer(withCode code: String, completion:@escaping (_ player: Player?) -> Void) {
        let url = "players"
        let parameters = [
            "pcode" : "\(code)",
            "seasoncode" : currentSeason.getSeasonCode()
        ]
        ApiClient.getRequestFrom(url: url,
                                 parameters: parameters,
                                 headers: [:]) { [weak self] data, error in
                                    if let xmlData = data, error == nil {
                                        DispatchQueue.global().async {
                                            self?.parsePlayerData(xmlData, code: code) { player in
                                                completion(player.clone())
                                            }
                                        }
                                    } else {
                                        completion(nil)
                                        print("error in Player data with code \(code)")
                                    }
        }
    }

    func parsePlayerData(_ xmlData: Data, code: String, completion: (Player) -> Void) {
        let xml = SWXMLHash.parse(xmlData)
        let player = Player()
        for elem in xml["player"].all {
            player.parsePlayerData(elem)
        }
        if player.name != "" {
            player.code = code
            player.seasonCode = currentSeason.getSeasonCode()
            RealmDBManager.sharedInstance.addPlayer(player)
            completion(player.clone())
        }

    }
}
