//
//  BoxScoreView.swift
//  Euroleague-Swift
//
//  Created by Modeso on 5/8/17.
//  Copyright © 2017 modeso. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation

protocol BoxScoreViewModelDelegate: class {
    func updateData(withLocalTeam localTeamDetail: GameTeamDetail?, roadTeam roadTeamDetail: GameTeamDetail?)
}

class BoxScoreViewModel {
    
    fileprivate let gameDetailBoxScoreService: GameDetailBoxScoreDataService
    
    weak var delegate: BoxScoreViewModelDelegate?
    
    init(season: LeaguesCommenObjects.Season) {
        gameDetailBoxScoreService = GameDetailBoxScoreDataService(season: season)
        gameDetailBoxScoreService.delegate = self
    }

    func getGameDetail(ofGameWithCode code: String){
        gameDetailBoxScoreService.getScoreBoxResults(ofGameWithCode: code)
//            DispatchQueue.main.async {
//                completion(localTeamDetail, roadTeamDetail)
//            }
        
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
    
    deinit {
        print("deinit BoxScoreViewModel")
    }

}

extension BoxScoreViewModel: GameDetailBoxScoreDataServiceDelegate {
    
    func updateData(localTeamDetail localTeam: GameTeamDetail?, roadTeamDetail roadTeam: GameTeamDetail?) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.updateData(withLocalTeam: localTeam, roadTeam: roadTeam)
        }
    }
    
}


struct BoxScoreInfo {
    var name: String = ""
    var homeTeamPlayerName: String = ""
    var guestTeamPlayerName: String = ""
    var homeTeamPlayerPointText: String = ""
    var guestTeamPlayerPointText: String = ""
}
