//
//  PlayerViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation


class PlayerViewModel {
    
    fileprivate let playersDataService = PlayersDataService()
    
    func getPlayer(withCode code: String) -> Player? {
        let player = playersDataService.getPlayer(withCode: code)
        return player
    }
    
    func updatePlayer(withCode code: String, completion:@escaping (_ player:Player) -> Void){
        playersDataService.updatePlayer(withCode: code) { player in
            completion(player)
        }
    }
    
}

