//
//  GameDetailBoxScoreService.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/18/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import SWXMLHash

protocol GameDetailBoxScoreDataServiceDelegate: class {
    func updateData(localTeamDetail localTeam: GameTeamDetail?, roadTeamDetail roadTeam: GameTeamDetail?)
}

class GameDetailBoxScoreDataService {
    
    fileprivate var localTeamDetail: GameTeamDetail?
    fileprivate var roadTeamDetail: GameTeamDetail?
    
    weak var delegate: GameDetailBoxScoreDataServiceDelegate?
    
    fileprivate let currentSeason: LeaguesCommenObjects.Season
    
    init(season: LeaguesCommenObjects.Season) {
        currentSeason = season
    }
    
    func getScoreBoxResults(ofGameWithCode code: String, completion:@escaping (_ localTeamDetail: GameTeamDetail?, _ roadTeamDetail: GameTeamDetail?)->Void){
        DispatchQueue.global().async { [weak self] in
            let realmGame = RealmDBManager.sharedInstance.getGame(withCode: code)
            let game = realmGame?.clone()
            completion(game?.localTeamGameDetail?.clone(), game?.roadTeamGameDetail?.clone())
            if let code = game?.gameNumber {
                self?.updateScoreBoxResults(ofGameWithCode: String(code))
            }
        }
        
    }
    
    func updateScoreBoxResults(ofGameWithCode code: String) {
        let url = "games"
        let parameters = [
            "gamecode" : code,
            "seasoncode" : currentSeason.getSeasonCode()
        ]
        ApiClient.getRequestFrom(
            url: url,
            parameters: parameters,
            headers: [:]) { [weak self] (data, error) in
                if let xmlData = data, error == nil {
                    self?.parseGameDetailData(xmlData)
                    if var gameCode = self?.currentSeason.getSeasonCode() {
                        gameCode = "\(gameCode)_\(code)"
                        RealmDBManager.sharedInstance.updateGameTeamsDetailFor(gameWithCode: gameCode, localTeam: self?.localTeamDetail, roadTeam: self?.roadTeamDetail)
                    }
                    self?.delegate?.updateData(localTeamDetail: self?.localTeamDetail?.clone(), roadTeamDetail: self?.roadTeamDetail?.clone())
                }
        }
    }
    
    deinit {
        print("deinit GameDetailBoxScoreDataService")
    }
}

fileprivate extension GameDetailBoxScoreDataService {
    
    func parseGameDetailData(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        let mlocalTeamDetail = GameTeamDetail()
        let mroadTeamDetail = GameTeamDetail()
        mlocalTeamDetail.parseTeamGameDetail(xml["game"]["localclub"])
        mroadTeamDetail.parseTeamGameDetail(xml["game"]["roadclub"])
        if mlocalTeamDetail.code != "" {
            mlocalTeamDetail.seasonCode = currentSeason.getSeasonCode()
            localTeamDetail = mlocalTeamDetail
        }
        if mroadTeamDetail.code != "" {
            mroadTeamDetail.seasonCode = currentSeason.getSeasonCode()
            roadTeamDetail = mroadTeamDetail
        }
    }
}
