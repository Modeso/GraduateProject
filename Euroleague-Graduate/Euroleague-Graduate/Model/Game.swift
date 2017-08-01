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

class Game: Object{
    
    dynamic var round: String = ""
    dynamic var date: Date = Date()
    dynamic var time: String = ""
    dynamic var gameNumber: Int = 0
    dynamic var homeTv: String = ""
    dynamic var homeScore: Int = 0
    dynamic var awayTv: String = ""
    dynamic var awayScore: Int = 0
    dynamic var played: Bool = false
    dynamic var awayCode: String = ""
    dynamic var homeCode: String = ""
    dynamic var awayImageUrl: String = ""
    dynamic var homeImageUrl: String = ""
    
    override static func primaryKey() -> String? {
        return "gameNumber"
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
        } catch {
            
        }
    }
    
    func cloneGame() -> Game {
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
        return newGame
    }
    
}
