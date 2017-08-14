//
//  PlayerViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation


class TurkishLeaguePlayerViewModel {
    
    fileprivate let playersDataService: TurkishLeaguePlayersDataService
    
    init() {
        playersDataService = TurkishLeaguePlayersDataService()
        playersDataService.delegate = self
    }
    
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

extension TurkishLeaguePlayerViewModel: TurkishAirLinesPlayersDataServiceDelegate {
    
    func updateData(_ player: Player) {
        
    }
    
}
