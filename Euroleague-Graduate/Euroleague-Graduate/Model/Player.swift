//
//  Player.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import SWXMLHash

class Player: Object {
    
    //V2
    dynamic var code: String = ""
    dynamic var name: String = ""
    dynamic var dorsal: Int = 0
    dynamic var position: String = ""
    dynamic var countryName: String = ""
    dynamic var imageUrl: String = ""
    
    //V7
    dynamic var seasonCode: String = ""
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
}

extension Player {
    
    func clone() -> Player {
        let newPlayer = Player()
        newPlayer.code = self.code
        newPlayer.name = self.name
        newPlayer.dorsal = self.dorsal
        newPlayer.position = self.position
        newPlayer.countryName = self.countryName
        newPlayer.imageUrl = self.imageUrl
        newPlayer.seasonCode = self.seasonCode
        return newPlayer
    }
    
    func parsePlayerData(_ node: XMLIndexer) {
        do {
            self.name = try node["name"].value()
            self.position = try node["position"].value()
            self.countryName = try node["country"].value()
            self.imageUrl = try node["imageurl"].value()
            if self.position != "coach" {
                self.dorsal = try node["dorsal"].value()
            }
            self.seasonCode = LeaguesCommenObjects.season.getSeasonCode()
        } catch {
            print(error)
        }
    }
    
}
