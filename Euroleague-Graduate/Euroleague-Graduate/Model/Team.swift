//
//  Team.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/31/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import SWXMLHash

class Team: Object {
    
    //V1
    dynamic var code: String = ""
    dynamic var tvCode: String = ""
    dynamic var name: String = ""
    dynamic var countryName: String = ""
    dynamic var countryCode: String = ""
    dynamic var logoUrl: String = ""
    dynamic var twitterAccount: String = ""
    
    //V2
    var rosters = List<Player>()
    
    //V3
    dynamic var coach: Player?
    
    //V7
    dynamic var seasonCode: String = ""
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
}

extension Team {
    
    func parseTeamData(_ node: XMLIndexer) {
        do {
            self.code = try node.value(ofAttribute: "code")
            self.tvCode = try node.value(ofAttribute: "tvcode")
            self.name = try node["name"].value()
            self.countryCode = try node["countrycode"].value()
            self.countryName = try node["countryname"].value()
            self.logoUrl = try node["imageurl"].value()
            self.twitterAccount = try node["twitteraccount"].value()
            self.coach = Player()
            self.coach?.name = try node["coach"].value(ofAttribute: "name")
            self.coach?.countryName = try node["coach"].value(ofAttribute: "countryname")
            self.coach?.code = try node["coach"].value(ofAttribute: "code")
            self.coach?.position = "Coach"
            if let coach = self.coach {
                self.rosters.append(coach)
            }
            for elem in node["roster"]["player"].all {
                let player = Player()
                player.name = try elem.value(ofAttribute: "name")
                player.code = try elem.value(ofAttribute: "code")
                player.dorsal = try elem.value(ofAttribute: "dorsal")
                player.position = try elem.value(ofAttribute: "position")
                player.countryName = try elem.value(ofAttribute: "countryname")
                self.rosters.append(player)
            }
        } catch {
            print(error)
        }
    }
    
    func clone() -> Team {
        let newTeam = Team()
        newTeam.code = self.code
        newTeam.countryCode = self.countryCode
        newTeam.countryName = self.countryName
        newTeam.logoUrl = self.logoUrl
        newTeam.name = self.name
        newTeam.tvCode = self.tvCode
        newTeam.twitterAccount = self.twitterAccount
        newTeam.coach = self.coach?.clone()
        let newRosters = List<Player>()
        for player in self.rosters {
            newRosters.append(player.clone())
        }
        newTeam.rosters = newRosters
        newTeam.seasonCode = self.seasonCode
        return newTeam
    }
    
}
