//
//  EBSGameDetailsClubInfo.swift
//  EuroleagueKit
//
//  Created by Esraa sorour on 4/27/17.
//  Copyright © 2017 modeso. All rights reserved.
//

import Foundation

public class EBSGameDetailsClubInfo {
    public dynamic var pkey: String = ""
    public dynamic var seasonCode: String = ""
    public dynamic var code: String = ""
    public dynamic var name: String = ""
    public dynamic var tvCode: String = ""
    public dynamic var score: String = ""
    public dynamic var coachCode: String = ""
    public dynamic var coachName: String = ""

    public dynamic var partial1: Int = 0
    public dynamic var partial2: Int = 0
    public dynamic var partial3: Int = 0
    public dynamic var partial4: Int = 0
    public dynamic var extraPeriod1: Int = 0
    public dynamic var extraPeriod2: Int = 0
    public dynamic var extraPeriod3: Int = 0
    public dynamic var extraPeriod4: Int = 0
    public dynamic var extraPeriod5: Int = 0

    public dynamic var phaseTypeCode: String = ""

//    public dynamic var playersStats: [EBSGamePlayerStats]?
//
//    public dynamic var total: EBSGameTeamStats?
//
//    public dynamic var gameQuotes: [EBSGameQuotes]?
//
//    // MARK: - Get statistics methods
//    public func mvpForPoints() -> EBSGamePlayerStats? {
//        let results = self.playersStats?.sorted(by: { $0.score > $1.score })
//        return getPlayerStats(results: results)
//    }
//
//    public func mvpForRebounds() -> EBSGamePlayerStats? {
//        let results = self.playersStats?.sorted(by: { $0.totalRebounds > $1.totalRebounds })
//        return getPlayerStats(results: results)
//    }
//
//    public func mvpForAssistances() -> EBSGamePlayerStats? {
//        let results = self.playersStats?.sorted(by: { $0.assistances > $1.assistances })
//        return getPlayerStats(results: results)
//    }
//
//    public func mvpForSteals() -> EBSGamePlayerStats? {
//        let results = self.playersStats?.sorted(by: { $0.steals > $1.steals })
//        return getPlayerStats(results: results)
//    }
//
//    public func mvpForBlocksFavour() -> EBSGamePlayerStats? {
//        let results = self.playersStats?.sorted(by: { $0.blockFavour > $1.blockFavour })
//        return getPlayerStats(results: results)
//    }
//
//    private func getPlayerStats(results: [EBSGamePlayerStats]?) -> EBSGamePlayerStats? {
//        let playerStat = results?.first
//        if !(playerStat?.playerName == "Team" && playerStat?.playerCode == nil) {
//            return playerStat
//        } else if let res = results, res.count > 2 {
//            return res[1]
//        }
//
//        return nil
//    }

}
