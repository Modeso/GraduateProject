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
    
    dynamic var roasterImageUrl: String = ""
    
    dynamic var nameSortValue: String = ""          //what is this??????
    
    dynamic var twitterAccount: String = ""
}

extension Team {
    
    func parseTeamData(_ node: XMLIndexer) throws -> Team {
        let team = Team()
        team.code = try node.value(ofAttribute: "code")
        team.tvCode = try node.value(ofAttribute: "tvcode")
        team.name = try node["name"].value()
        
        return team
    }
}
