//
//  CommenFunctions.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/26/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

class CommonFunctions {
    
    func convertDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: date)!
    }
    
    func getGameDataSet(_ game: GameData) -> GameData {
        let newGame = GameData()
        newGame.awayScore = game.awayScore
        newGame.awayTv = game.awayTv
        newGame.date = game.date
        newGame.gameNumber = game.gameNumber
        newGame.homeScore = game.homeScore
        newGame.homeTv = game.homeTv
        newGame.played = game.played
        newGame.round = game.round
        newGame.time = game.time
        return newGame
    }
    
}
