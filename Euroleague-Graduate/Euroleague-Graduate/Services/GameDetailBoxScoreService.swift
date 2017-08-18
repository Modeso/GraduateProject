//
//  GameDetailBoxScoreService.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/18/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import SWXMLHash

protocol GameDetailBoxScoreDataServiceDelegate {
    func updateData(localTeamDetail localTeam: GameTeamDetail?, roadTeamDetail roadTeam: GameTeamDetail?)
}

class GameDetailBoxScoreService {
    
    fileprivate var localTeamDetail: GameTeamDetail?
    fileprivate var roadTeamDetail: GameTeamDetail?
    
    var delegate: GameDetailBoxScoreDataServiceDelegate?
    
    func getScoreBoxResults(ofGameWithCode gameCode: String) {
        let url = "games"
        let parameters = [
            "gamecode" : gameCode,
            "seasoncode" : LeaguesCommenObjects.season
        ]
        ApiClient.getRequestFrom(
            url: url,
            parameters: parameters,
            headers: [:]) { [weak self] (data, error) in
                if let xmlData = data, error == nil {
                    self?.parseGameDetailData(xmlData)
                    self?.delegate?.updateData(localTeamDetail: self?.localTeamDetail, roadTeamDetail: self?.roadTeamDetail)
                }
        }
    }
}

fileprivate extension GameDetailBoxScoreService {
    
    func parseGameDetailData(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        localTeamDetail = GameTeamDetail()
        roadTeamDetail = GameTeamDetail()
        localTeamDetail?.parseTeamGameDetail(xml["game"]["localclub"])
        roadTeamDetail?.parseTeamGameDetail(xml["game"]["roadclub"])
    }
}
