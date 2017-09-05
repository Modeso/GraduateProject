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

public class Player: Object {

    //V2
    public dynamic var code: String = ""
    public dynamic var name: String = ""
    public dynamic var dorsal: Int = 0
    public dynamic var position: String = ""
    public dynamic var countryName: String = ""
    public dynamic var imageUrl: String = ""

    //V7
    public dynamic var seasonCode: String = ""

    //V10
    var team = LinkingObjects(fromType: Team.self, property: "rosters")

    override public static func primaryKey() -> String? {
        return "code"
    }

}

public extension Player {

    public func clone() -> Player {
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

    public func parsePlayerData(_ node: XMLIndexer) {
        do {
            self.name = try node["name"].value()
            self.position = try node["position"].value()
            self.countryName = try node["country"].value()
            self.imageUrl = try node["imageurl"].value()
            if self.position != "coach" {
                self.dorsal = try node["dorsal"].value()
            }
        } catch {
            print(error)
        }
    }

}
