//
//  PlayerViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

class PlayerViewModel {

    fileprivate let playersDataService: PlayersDataService

    init(season: LeaguesCommenObjects.Season) {
        playersDataService = PlayersDataService(season: season)
    }

    func getPlayer(withCode code: String, completion:@escaping (Player?) -> Void) {
        playersDataService.getPlayer(withCode: code) { (player) in
            DispatchQueue.main.async {
                completion(player)
            }
        }
    }

    func updatePlayer(withCode code: String, completion:@escaping (_ player: Player) -> Void) {
        playersDataService.updatePlayer(withCode: code) { player in
            DispatchQueue.main.async {
                completion(player)
            }
        }
    }

    deinit {
        print("deinit PlayerViewModel")
    }
}
