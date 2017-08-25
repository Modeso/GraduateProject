//
//  GameDetail.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/18/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import SWXMLHash

class GameTeamDetail: Object {
    //V5
    dynamic var seasonCode: String = ""
    dynamic var code: String = ""
    
    dynamic var partial1: Int = 0
    dynamic var partial2: Int = 0
    dynamic var partial3: Int = 0
    dynamic var partial4: Int = 0
    dynamic var extraPeriod1: Int = 0
    dynamic var extraPeriod2: Int = 0
    dynamic var extraPeriod3: Int = 0
    dynamic var extraPeriod4: Int = 0
    dynamic var extraPeriod5: Int = 0
    
    var playersStats = List<GamePlayerStats>()
    
    //    override static func ignoredProperties() -> [String] {
    //        return ["playersStatus"]
    //    }
    
}

extension GameTeamDetail {
    
    func clone() -> GameTeamDetail {
        let newTeamGameDetail = GameTeamDetail()
        newTeamGameDetail.seasonCode = self.seasonCode
        newTeamGameDetail.code = self.code
        newTeamGameDetail.partial1 = self.partial1
        newTeamGameDetail.partial2 = self.partial2
        newTeamGameDetail.partial3 = self.partial3
        newTeamGameDetail.partial4 = self.partial4
        newTeamGameDetail.extraPeriod1 = self.extraPeriod1
        newTeamGameDetail.extraPeriod2 = self.extraPeriod2
        newTeamGameDetail.extraPeriod3 = self.extraPeriod3
        newTeamGameDetail.extraPeriod4 = self.extraPeriod4
        newTeamGameDetail.extraPeriod5 = self.extraPeriod5
        let newPlayerStatus = List<GamePlayerStats>()
        for playerStats in self.playersStats {
            newPlayerStatus.append(playerStats.clone())
        }
        newTeamGameDetail.playersStats = newPlayerStatus
        return newTeamGameDetail
    }
    
    func parseTeamGameDetail(_ node: XMLIndexer) {
        do {
            self.code = try node.value(ofAttribute: "code")
            self.partial1 = try node["partials"].value(ofAttribute: "Partial1")
            self.partial2 = try node["partials"].value(ofAttribute: "Partial2")
            self.partial3 = try node["partials"].value(ofAttribute: "Partial3")
            self.partial4 = try node["partials"].value(ofAttribute: "Partial4")
            self.extraPeriod1 = try node["partials"].value(ofAttribute: "ExtraPeriod1")
            self.extraPeriod2 = try node["partials"].value(ofAttribute: "ExtraPeriod2")
            self.extraPeriod3 = try node["partials"].value(ofAttribute: "ExtraPeriod3")
            self.extraPeriod4 = try node["partials"].value(ofAttribute: "ExtraPeriod4")
            self.extraPeriod5 = try node["partials"].value(ofAttribute: "ExtraPeriod5")
            for elem in node["playerstats"]["stat"].all {
                let playerStats = GamePlayerStats()
                playerStats.parseStatusData(elem)
                self.playersStats.append(playerStats)
            }
        } catch {
            print(error)
        }
    }
    
    func getQuarter(ofRow row:Int) -> Int {
        switch row {
        case 0:
            return partial1
        case 1:
            return partial2
        case 2:
            return partial3
        case 3:
            return partial4
        case 4:
            return extraPeriod1
        case 5:
            return extraPeriod2
        case 6:
            return extraPeriod3
        case 7:
            return extraPeriod4
        case 8:
            return extraPeriod5
        default:
            return 0
        }
    }
    
    // MARK: - Get statistics methods
    func mvpForPoints() -> GamePlayerStats? {
        let results = self.playersStats.sorted(by: { $0.score > $1.score })
        return getPlayerStats(results: results)
    }
    
    func mvpForRebounds() -> GamePlayerStats? {
        let results = self.playersStats.sorted(by: { $0.totalRebounds > $1.totalRebounds })
        return getPlayerStats(results: results)
    }
    
    func mvpForAssistances() -> GamePlayerStats? {
        let results = self.playersStats.sorted(by: { $0.assistances > $1.assistances })
        return getPlayerStats(results: results)
    }
    
    func mvpForSteals() -> GamePlayerStats? {
        let results = self.playersStats.sorted(by: { $0.steals > $1.steals })
        return getPlayerStats(results: results)
    }
    
    func mvpForBlocksFavour() -> GamePlayerStats? {
        let results = self.playersStats.sorted(by: { $0.blockFavour > $1.blockFavour })
        return getPlayerStats(results: results)
    }
    
    private func getPlayerStats(results: [GamePlayerStats]?) -> GamePlayerStats? {
        let playerStat = results?.first
        if !(playerStat?.playerName == "Team" && playerStat?.playerCode == "") {
            return playerStat
        } else if let res = results, res.count > 2 {
            return res[1]
        }
        return nil
    }
}
