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
    
    dynamic var seasonCode: String = ""             //why do we need this isn't the data already get using a seasonCode
    
    dynamic var code: String = ""
    
    dynamic var tvCode: String = ""
    
    dynamic var name: String = ""
    
    dynamic var countryName: String = ""
    
    dynamic var countryCode: String = ""
    
    dynamic var logoUrl: String = ""
    
    dynamic var rosterImageUrl: String = ""
    
    dynamic var nameSortValue: String = ""          //what is this??????
    
    dynamic var twitterAccount: String = ""
    
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
        } catch {
            
        }
    }
    
    func cloneTeam() -> Team {
        let newTeam = Team()
        newTeam.code = self.code
        newTeam.countryCode = self.countryCode
        newTeam.countryName = self.countryName
        newTeam.logoUrl = self.logoUrl
        newTeam.name = self.name
        newTeam.nameSortValue = self.nameSortValue
        newTeam.rosterImageUrl = self.rosterImageUrl
        newTeam.seasonCode = self.seasonCode
        newTeam.tvCode = self.tvCode
        newTeam.twitterAccount = self.twitterAccount
        return newTeam
    }
    
}
