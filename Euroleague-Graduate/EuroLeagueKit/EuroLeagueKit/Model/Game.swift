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

public class Game: Object {

    //V0
    public dynamic var round: String = ""
    public dynamic var date: Date = Date()
    public dynamic var time: String = ""
    public dynamic var gameNumber: Int = 0
    public dynamic var homeTv: String = ""
    public dynamic var homeScore: Int = 0
    public dynamic var awayTv: String = ""
    public dynamic var awayScore: Int = 0
    public dynamic var played: Bool = false

    //V1
    public dynamic var awayCode: String = ""
    public dynamic var homeCode: String = ""
    public dynamic var awayImageUrl: String = ""
    public dynamic var homeImageUrl: String = ""

    //V5
    public dynamic var localTeamGameDetail: GameTeamDetail?
    public dynamic var roadTeamGameDetail: GameTeamDetail?

    //V6
    public dynamic var seasonCode: String = ""
    public dynamic var gameCode: String = ""

    override public static func primaryKey() -> String? {
        return "gameCode"
    }

    override public static func ignoredProperties() -> [String] {
        return ["awayImageUrl", "homeImageUrl"]
    }

}

public extension Game {

    public func parseGameData(_ node: XMLIndexer) {
        do {
            self.round = try node["round"].value()
            let mdate: String = try node["date"].value()
            self.date = mdate.convertStringToDate()
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

    public func clone() -> Game {
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

    public func getQuartersPlayed() -> Int {
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
