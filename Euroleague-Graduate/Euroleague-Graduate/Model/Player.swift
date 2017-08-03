//
//  Player.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

class Player: Object {
    
    dynamic var code: String = ""
    
    dynamic var name: String = ""
    
    dynamic var dorsal:Int = 0
    
    dynamic var position: String = ""
    
    dynamic var countryName: String = ""
    
    dynamic var imageUrl: String = ""
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
}

extension Player {
    
    func clone() -> Player {
        let newPlayer = Player()
        newPlayer.name = self.name
        newPlayer.dorsal = self.dorsal
        newPlayer.position = self.position
        newPlayer.countryName = self.countryName
        newPlayer.imageUrl = self.imageUrl
        return newPlayer
    }
    
}
