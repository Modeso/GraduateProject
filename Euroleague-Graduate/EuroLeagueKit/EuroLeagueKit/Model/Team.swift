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

public class Team: Object {

    //V1
    public dynamic var code: String = ""
    public dynamic var tvCode: String = ""
    public dynamic var name: String = ""
    public dynamic var countryName: String = ""
    public dynamic var countryCode: String = ""
    public dynamic var logoUrl: String = ""
    public dynamic var twitterAccount: String = ""

    //V2
    public var rosters = List<Player>()

    //V3
   // dynamic var coach: Player?

    //V7
    public dynamic var seasonCode: String = ""

    override public static func primaryKey() -> String? {
        return "code"
    }

}

public extension Team {

    public func parseTeamData(_ node: XMLIndexer) {
        do {
            self.code = try node.value(ofAttribute: "code")
            self.tvCode = try node.value(ofAttribute: "tvcode")
            self.name = try node["name"].value()
            self.countryCode = try node["countrycode"].value()
            self.countryName = try node["countryname"].value()
            self.logoUrl = try node["imageurl"].value()
            self.twitterAccount = try node["twitteraccount"].value()

            let coach = Player()
            coach.name = try node["coach"].value(ofAttribute: "name")
            coach.countryName = try node["coach"].value(ofAttribute: "countryname")
            coach.code = try node["coach"].value(ofAttribute: "code")
            coach.position = "Coach"
            coach.seasonCode = self.seasonCode
            self.rosters.append(coach)
            for elem in node["roster"]["player"].all {
                let player = Player()
                player.name = try elem.value(ofAttribute: "name")
                player.code = try elem.value(ofAttribute: "code")
                player.dorsal = try elem.value(ofAttribute: "dorsal")
                player.position = try elem.value(ofAttribute: "position")
                player.countryName = try elem.value(ofAttribute: "countryname")
                player.seasonCode = self.seasonCode
                self.rosters.append(player)
            }
        } catch {
            print(error)
        }
    }

    public func clone() -> Team {
        let newTeam = Team()
        newTeam.code = self.code
        newTeam.countryCode = self.countryCode
        newTeam.countryName = self.countryName
        newTeam.logoUrl = self.logoUrl
        newTeam.name = self.name
        newTeam.tvCode = self.tvCode
        newTeam.twitterAccount = self.twitterAccount
//        newTeam.coach = self.coach?.clone()
        let newRosters = List<Player>()
        for player in self.rosters {
            newRosters.append(player.clone())
        }
        newTeam.rosters = newRosters
        newTeam.seasonCode = self.seasonCode
        return newTeam
    }

}
