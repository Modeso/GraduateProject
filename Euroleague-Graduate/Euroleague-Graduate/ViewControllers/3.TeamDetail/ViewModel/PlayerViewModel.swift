//
//  PlayerViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

class PlayerViewModel: AbstractViewModel {

    fileprivate let playersDataService: PlayersDataService

    init(season: Constants.Season) {
        playersDataService = PlayersDataService(season: season)
    }

    func getData(withData data: [Any]?, completion: @escaping ([NSArray]?) -> Void) {
        if let code = data?[0] as? String {
            getPlayer(withCode: code, completion: completion)
        }
    }

}

fileprivate extension PlayerViewModel {

    func getPlayer(withCode code: String, completion:@escaping ([NSArray]?) -> Void) {
        playersDataService.getPlayer(withCode: code) { (player) in
            DispatchQueue.main.async {
                var array: [[Player]]? = [[Player]]()
                if let mPlayer = player {
                    var subArray = [Player]()
                    subArray.append(mPlayer)
                    array?.append(subArray)
                }
                DispatchQueue.main.async {
                    completion(array as [NSArray]?)
                }
            }
        }
    }

}
