//
//  GameData.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/20/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import SWXMLHash

class Game: Object {
    //V0
    dynamic var round: String = ""
    dynamic var date: Date = Date()
    dynamic var time: String = ""
    dynamic var gameNumber: Int = 0
    dynamic var homeTv: String = ""
    dynamic var homeScore: Int = 0
    dynamic var awayTv: String = ""
    dynamic var awayScore: Int = 0
    dynamic var played: Bool = false
    
    //V1
    dynamic var awayCode: String = ""
    dynamic var homeCode: String = ""
    dynamic var awayImageUrl: String = ""
    dynamic var homeImageUrl: String = ""
    
    //V5
    dynamic var localTeamGameDetail: GameTeamDetail?
    dynamic var roadTeamGameDetail: GameTeamDetail?
    
    //V6
    dynamic var seasonCode: String = ""
    dynamic var gameCode: String = ""
    
    override static func primaryKey() -> String? {
        return "gameCode"
    }

    override static func ignoredProperties() -> [String] {
        return ["awayImageUrl", "homeImageUrl"]
    }
    
}

extension Game {
    
    func parseGameData(_ node: XMLIndexer){
        do {
            self.round = try node["round"].value()
            self.date = Date().convertStringToDate(date: try node["date"].value())
            self.time = try node["startime"].value()
            self.gameNumber = try node["game"].value()
            self.homeTv = try node["hometv"].value()
            self.awayTv = try node["awaytv"].value()
            self.played = try node["played"].value()
            self.awayCode = try node["awaycode"].value()
            self.homeCode = try node["homecode"].value()
            self.gameCode = try node["gamecode"].value()
        } catch {
            
        }
    }
    
    func clone() -> Game {
        let newGame = Game()
        newGame.awayScore = self.awayScore
        newGame.awayTv = self.awayTv
        newGame.date = self.date
        newGame.gameNumber = self.gameNumber
        newGame.homeScore = self.homeScore
        newGame.homeTv = self.homeTv
        newGame.played = self.played
        newGame.round = self.round
        newGame.time = self.time
        newGame.awayCode = self.awayCode
        newGame.homeCode = self.homeCode
        newGame.localTeamGameDetail = self.localTeamGameDetail?.clone()
        newGame.roadTeamGameDetail = self.roadTeamGameDetail?.clone()
        newGame.seasonCode = self.seasonCode
        newGame.gameCode = self.gameCode
        return newGame
    }
    
    func getQuartersPlayed() -> Int {
        var count = 4
        guard let localTeam = localTeamGameDetail?.clone(), let roadTeam = roadTeamGameDetail?.clone()
            else { return count }
        if localTeam.extraPeriod1 != 0 || localTeam.extraPeriod2 != 0
            || roadTeam.extraPeriod1 != 0 || roadTeam.extraPeriod2 != 0 {
            count = 6
        }
        if localTeam.extraPeriod3 != 0 || localTeam.extraPeriod4 != 0
            || roadTeam.extraPeriod3 != 0 || roadTeam.extraPeriod4 != 0 {
            count = 8
        }
        if localTeam.extraPeriod5 != 0 || roadTeam.extraPeriod5 != 0 {
            count = 10
        }
        return count
    }
    
}
