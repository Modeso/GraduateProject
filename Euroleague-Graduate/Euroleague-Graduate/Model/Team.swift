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
    
    dynamic var code: String = ""
    
    dynamic var tvCode: String = ""
    
    dynamic var name: String = ""
    
    dynamic var countryName: String = ""
    
    dynamic var countryCode: String = ""
    
    dynamic var logoUrl: String = ""
    
    dynamic var rosterImageUrl: String = ""
    
    dynamic var twitterAccount: String = ""
    
    dynamic var coachName: String = ""
    
    dynamic var coachCountry: String = ""
    
    var rosters = List<Player>()
    
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
            self.rosterImageUrl = try node["rosterimageurl"].value()
            self.twitterAccount = try node["twitteraccount"].value()
            self.coachName = try node["coach"].value(ofAttribute: "name")
            self.coachCountry = try node["coach"].value(ofAttribute: "countryname")
            for elem in node["roster"]["player"].all {
                let player = Player()
                player.name = try elem.value(ofAttribute: "name")
                player.code = try elem.value(ofAttribute: "code")
                player.dorsal = try elem.value(ofAttribute: "dorsal")
                player.position = try elem.value(ofAttribute: "position")
                player.countryName = try elem.value(ofAttribute: "countryname")
            }
        } catch {
            
        }
    }
    
    func clone() -> Team {
        let newTeam = Team()
        newTeam.code = self.code
        newTeam.countryCode = self.countryCode
        newTeam.countryName = self.countryName
        newTeam.logoUrl = self.logoUrl
        newTeam.name = self.name
        newTeam.rosterImageUrl = self.rosterImageUrl
        newTeam.tvCode = self.tvCode
        newTeam.twitterAccount = self.twitterAccount
        newTeam.coachName = self.coachName
        newTeam.coachCountry = self.coachCountry
        newTeam.rosters = self.rosters
        return newTeam
    }
    
}
