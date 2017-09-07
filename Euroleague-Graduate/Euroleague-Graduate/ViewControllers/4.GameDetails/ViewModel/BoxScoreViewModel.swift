//
//  BoxScoreView.swift
//  Euroleague-Swift
//
//  Created by Modeso on 5/8/17.
//  Copyright © 2017 modeso. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation
import EuroLeagueKit

protocol BoxScoreViewModelDelegate: class {
    func updateData(withLocalTeam localTeamDetail: GameTeamDetail?, roadTeam roadTeamDetail: GameTeamDetail?)
}

class BoxScoreViewModel: AbstractViewModel {

    fileprivate let gameDetailBoxScoreService: GameDetailBoxScoreDataService

    init(season: Constants.Season) {
        gameDetailBoxScoreService = GameDetailBoxScoreDataService(season: season)
    }

    func getData(withData data: [Any]?, completion: @escaping ([Any]?) -> Void) {
        if let code = data?[0] as? String {
            DispatchQueue.global().async { [weak self] in
                self?.gameDetailBoxScoreService.getScoreBoxResults(ofGameWithCode: code) {(localTeamDetail, roadTeamDetail) in
                    var array: [GameTeamDetail]? = [GameTeamDetail]()
                    guard let local = localTeamDetail, let road = roadTeamDetail
                        else {
                            completion(nil)
                            return
                    }
                    array?.append(local)
                    array?.append(road)
                    DispatchQueue.main.async {
                        completion(array as [Any]?)
                    }
                }
            }
        }
    }

    func boxScoreInfo(forIndex index: Int,
                      withLocalTeam localTeam: GameTeamDetail,
                      withRoadTeam roadTeam: GameTeamDetail) -> BoxScoreInfo {

        var boxScoreInfo = BoxScoreInfo()

        var homeGamePlayerStats: GamePlayerStats?
        var guestGamePlayerStats: GamePlayerStats?

        switch index {
        case 0:
            boxScoreInfo.name = "PTS"
            homeGamePlayerStats = localTeam.mvpForPoints()
            guestGamePlayerStats = roadTeam.mvpForPoints()
            boxScoreInfo.homeTeamPlayerPointText = "\(homeGamePlayerStats?.score ?? 0)"
            boxScoreInfo.guestTeamPlayerPointText = "\(guestGamePlayerStats?.score ?? 0)"
            break
        case 1:
            boxScoreInfo.name = "RB"
            homeGamePlayerStats = localTeam.mvpForRebounds()
            guestGamePlayerStats = roadTeam.mvpForRebounds()
            boxScoreInfo.homeTeamPlayerPointText = "\(homeGamePlayerStats?.totalRebounds ?? 0)"
            boxScoreInfo.guestTeamPlayerPointText = "\(guestGamePlayerStats?.totalRebounds ?? 0)"
            break
        case 2:
            boxScoreInfo.name = "AS"
            homeGamePlayerStats = localTeam.mvpForAssistances()
            guestGamePlayerStats = roadTeam.mvpForAssistances()
            boxScoreInfo.homeTeamPlayerPointText = "\(homeGamePlayerStats?.assistances ?? 0)"
            boxScoreInfo.guestTeamPlayerPointText = "\(guestGamePlayerStats?.assistances ?? 0)"
            break
        case 3:
            boxScoreInfo.name = "ST"
            homeGamePlayerStats = localTeam.mvpForSteals()
            guestGamePlayerStats = roadTeam.mvpForSteals()
            boxScoreInfo.homeTeamPlayerPointText = "\(homeGamePlayerStats?.steals ?? 0)"
            boxScoreInfo.guestTeamPlayerPointText = "\(guestGamePlayerStats?.steals ?? 0)"
            break
        default:
            boxScoreInfo.name = "BL Fv"
            homeGamePlayerStats = localTeam.mvpForBlocksFavour()
            guestGamePlayerStats = roadTeam.mvpForBlocksFavour()
            let homeBlocksFavour = homeGamePlayerStats?.blockFavour ?? 0
            var homeBlocksFavourStr = "-"
            if homeBlocksFavour > 0 {
                homeBlocksFavourStr = "\(homeBlocksFavour)"
                boxScoreInfo.homeTeamPlayerName = homeGamePlayerStats?.playerName ?? ""

            }

            let guestBlocksFavour = guestGamePlayerStats?.blockFavour ?? 0
            var guestBlocksFavourStr = "-"
            if guestBlocksFavour > 0 {
                guestBlocksFavourStr = "\(guestBlocksFavour)"
                boxScoreInfo.guestTeamPlayerName = guestGamePlayerStats?.playerName ?? ""

            }

            boxScoreInfo.homeTeamPlayerPointText = homeBlocksFavourStr
            boxScoreInfo.guestTeamPlayerPointText = guestBlocksFavourStr

            break
        }

        if index < 4 {
            boxScoreInfo.homeTeamPlayerName = homeGamePlayerStats?.playerName ?? ""
            boxScoreInfo.guestTeamPlayerName = guestGamePlayerStats?.playerName ?? ""

        }
        return boxScoreInfo
    }

}

struct BoxScoreInfo {
    var name: String = ""
    var homeTeamPlayerName: String = ""
    var guestTeamPlayerName: String = ""
    var homeTeamPlayerPointText: String = ""
    var guestTeamPlayerPointText: String = ""
}
