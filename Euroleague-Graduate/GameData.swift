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

class GameData: Object{
    
    dynamic var round: String = ""
    dynamic var date: Date = Date()
    dynamic var time: String = ""
    dynamic var gameNumber: Int = 0
    dynamic var homeTv: String = ""
    dynamic var homeScore: Int = 0
    dynamic var awayTv: String = ""
    dynamic var awayScore: Int = 0
    dynamic var played: Bool = false
    
    override static func primaryKey() -> String? {
        return "gameNumber"
    }

}

extension GameData {
    
    func parseGameData(_ node: XMLIndexer) throws -> GameData {
        let game = GameData()
        game.round = try node["round"].value()
        game.date = Date().convertStringToDate(date: try node["date"].value())
        game.time = try node["startime"].value()
        game.gameNumber = try node["game"].value()
        game.homeTv = try node["hometv"].value()
        game.awayTv = try node["awaytv"].value()
        game.played = try node["played"].value()
        return game
    }
    
    func cloneGame() -> GameData {
        let newGame = GameData()
        newGame.awayScore = self.awayScore
        newGame.awayTv = self.awayTv
        newGame.date = self.date
        newGame.gameNumber = self.gameNumber
        newGame.homeScore = self.homeScore
        newGame.homeTv = self.homeTv
        newGame.played = self.played
        newGame.round = self.round
        newGame.time = self.time
        return newGame
    }
    
}
