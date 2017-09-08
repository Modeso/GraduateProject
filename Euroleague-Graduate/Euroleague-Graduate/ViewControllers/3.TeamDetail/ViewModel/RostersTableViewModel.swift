//
//  RostersTableViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import EuroLeagueKit

class RostersTableViewModel {

    fileprivate let playersDataService: PlayersDataService

    init(season: Constants.Season) {
        playersDataService = PlayersDataService(season: season)
    }

    func makeRostersOf(_ rosters: [Player]) -> [[Player]] {
        var players: [String : [Player]] = [:]
        var playersList: [[Player]] = []
        var rostersList = rosters
        let coach = rostersList[0]
        rostersList.remove(at: 0)
        var positions: [String] = []
        for player in rostersList {
            if !positions.contains(player.position) {
                positions.append(player.position)
                players[player.position] = []
            }
            players[player.position]?.append(player)
        }
        positions.sort()
        playersList.append([coach])
        for position in positions {
            let samePositionPlayers = players[position]?.sorted { $0.dorsal < $1.dorsal }
            if let sortedPlayers = samePositionPlayers {
                playersList.append(sortedPlayers)
            }
        }
        return playersList
    }

}

extension RostersTableViewModel: AbstractViewModel {

    func getData(withData data: [Any]?, completion: @escaping ([Any]?) -> Void) {
        if let code = data?[0] as? String {
            getPlayer(withCode: code, completion: completion)
        }
    }

}

fileprivate extension RostersTableViewModel {

    func getPlayer(withCode code: String, completion:@escaping ([Any]?) -> Void) {
        playersDataService.getPlayer(withCode: code) { (player) in
            DispatchQueue.main.async {
                if let mPlayer = player {
                    completion([mPlayer] as [Any]?)
                }
            }
        }
    }

}
