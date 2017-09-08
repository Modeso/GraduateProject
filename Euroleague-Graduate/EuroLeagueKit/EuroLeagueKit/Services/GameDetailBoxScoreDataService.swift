//
//  GameDetailBoxScoreService.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/18/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import SWXMLHash

public class GameDetailBoxScoreDataService {

    fileprivate var localTeamDetail: GameTeamDetail?
    fileprivate var roadTeamDetail: GameTeamDetail?

    fileprivate let currentSeason: Constants.Season

    public init(season: Constants.Season) {
        currentSeason = season
    }

    public func getScoreBoxResults(ofGameWithCode code: String,
                                   completion: @escaping (_ localTeamDetail: GameTeamDetail?, _ roadTeamDetail: GameTeamDetail?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            let realmGame = RealmDBManager.sharedInstance.getGame(withCode: code)
            let game = realmGame?.clone()
            completion(game?.localTeamGameDetail?.clone(), game?.roadTeamGameDetail?.clone())
            if let code = game?.gameNumber {
                self?.updateScoreBoxResults(ofGameWithCode: String(code), completion: completion)
            }
        }
    }
}

fileprivate extension GameDetailBoxScoreDataService {

    func updateScoreBoxResults(ofGameWithCode code: String,
                               completion: @escaping (_ localTeamDetail: GameTeamDetail?, _ roadTeamDetail: GameTeamDetail?) -> Void) {
        let url = "games"
        let parameters = [
            "gamecode": code,
            "seasoncode": currentSeason.getSeasonCode()
        ]
        ApiClient.getRequestFrom(
            url: url,
            parameters: parameters,
            headers: [:]) { [weak self] (data, error) in
                if let xmlData = data, error == nil {
                    DispatchQueue.global().async { [weak self] in
                        self?.parseGameDetailData(xmlData)
                        if var gameCode = self?.currentSeason.getSeasonCode() {
                            gameCode = "\(gameCode)_\(code)"
                            RealmDBManager.sharedInstance.updateGameTeamsDetailFor(gameWithCode: gameCode, localTeam: self?.localTeamDetail?.clone(), roadTeam: self?.roadTeamDetail?.clone())
                        }
                        completion(self?.localTeamDetail?.clone(), self?.roadTeamDetail?.clone())
                    }
                } else {
                    completion(nil, nil)
                }
        }
    }

    func parseGameDetailData(_ xmlData: Data) {
        let xml = SWXMLHash.parse(xmlData)
        let mlocalTeamDetail = GameTeamDetail()
        let mroadTeamDetail = GameTeamDetail()
        mlocalTeamDetail.parseTeamGameDetail(of: xml["game"]["localclub"])
        mroadTeamDetail.parseTeamGameDetail(of: xml["game"]["roadclub"])
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
