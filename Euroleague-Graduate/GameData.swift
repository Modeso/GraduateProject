//
//  GameData.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/20/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

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
