//
//  BoxScoreView.swift
//  Euroleague-Swift
//
//  Created by Modeso on 5/8/17.
//  Copyright © 2017 modeso. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation

class BoxScoreViewModel {
    
    fileprivate var quarters: [String]?
    
    func getQuarters() {
        
    }
    
    func getScores() {
        
    }
}

//import EuroleagueKit
//
//class BoxScoreViewModel {
//
//    func boxScoreInfo(forIndex index: Int) -> BoxScoreInfo {
//
//        var boxScoreInfo = BoxScoreInfo()
//
//        var homeGamePlayerStats: EBSGamePlayerStats?
//        var guestGamePlayerStats: EBSGamePlayerStats?
//        switch index {
//        case 0:
//            boxScoreInfo.name = "PTS"
//            homeGamePlayerStats = gameDetails?.localClub?.mvpForPoints()
//            guestGamePlayerStats = gameDetails?.roadClub?.mvpForPoints()
//            boxScoreInfo.homeTeamPlayerPointText = "\(homeGamePlayerStats?.score ?? 0)"
//            boxScoreInfo.guestTeamPlayerPointText = "\(guestGamePlayerStats?.score ?? 0)"
//            break
//        case 1:
//            boxScoreInfo.name = "RB"
//            homeGamePlayerStats = gameDetails?.localClub?.mvpForRebounds()
//            guestGamePlayerStats = gameDetails?.roadClub?.mvpForRebounds()
//            boxScoreInfo.homeTeamPlayerPointText = "\(homeGamePlayerStats?.totalRebounds ?? 0)"
//            boxScoreInfo.guestTeamPlayerPointText = "\(guestGamePlayerStats?.totalRebounds ?? 0)"
//            break
//        case 2:
//            boxScoreInfo.name = "AS"
//            homeGamePlayerStats = gameDetails?.localClub?.mvpForAssistances()
//            guestGamePlayerStats = gameDetails?.roadClub?.mvpForAssistances()
//            boxScoreInfo.homeTeamPlayerPointText = "\(homeGamePlayerStats?.assistances ?? 0)"
//            boxScoreInfo.guestTeamPlayerPointText = "\(guestGamePlayerStats?.assistances ?? 0)"
//            break
//        case 3:
//            boxScoreInfo.name = "ST"
//            homeGamePlayerStats = gameDetails?.localClub?.mvpForSteals()
//            guestGamePlayerStats = gameDetails?.roadClub?.mvpForSteals()
//            boxScoreInfo.homeTeamPlayerPointText = "\(homeGamePlayerStats?.steals ?? 0)"
//            boxScoreInfo.guestTeamPlayerPointText = "\(guestGamePlayerStats?.steals ?? 0)"
//            break
//        default:
//            boxScoreInfo.name = "BL Fv"
//            homeGamePlayerStats = gameDetails?.localClub?.mvpForBlocksFavour()
//            guestGamePlayerStats = gameDetails?.roadClub?.mvpForBlocksFavour()
//            let homeBlocksFavour = homeGamePlayerStats?.blockFavour ?? 0
//            var homeBlocksFavourStr = "-"
//            if homeBlocksFavour > 0 {
//                homeBlocksFavourStr = "\(homeBlocksFavour)"
//                boxScoreInfo.homeTeamPlayerName = homeGamePlayerStats?.playerName ?? ""
//                if let playerCode = homeGamePlayerStats?.playerCode {
//                    boxScoreInfo.homeTeamPlayer = getPlayer(withCode:playerCode, fromTeam: homeTeam)
//                }
//            }
//
//            let guestBlocksFavour = guestGamePlayerStats?.blockFavour ?? 0
//            var guestBlocksFavourStr = "-"
//            if guestBlocksFavour > 0 {
//                guestBlocksFavourStr = "\(guestBlocksFavour)"
//                boxScoreInfo.guestTeamPlayerName = guestGamePlayerStats?.playerName ?? ""
//                if let playerCode = guestGamePlayerStats?.playerCode {
//                    boxScoreInfo.guestTeamPlayer = getPlayer(withCode:playerCode, fromTeam: guestTeam)
//                }
//            }
//
//            boxScoreInfo.homeTeamPlayerPointText = homeBlocksFavourStr
//            boxScoreInfo.guestTeamPlayerPointText = guestBlocksFavourStr
//
//            break
//        }
//
//        if index < 4 {
//            boxScoreInfo.homeTeamPlayerName = homeGamePlayerStats?.playerName ?? ""
//            boxScoreInfo.guestTeamPlayerName = guestGamePlayerStats?.playerName ?? ""
//            if let playerCode = homeGamePlayerStats?.playerCode {
//                boxScoreInfo.homeTeamPlayer = getPlayer(withCode:playerCode, fromTeam: homeTeam)
//            }
//            if let playerCode = guestGamePlayerStats?.playerCode {
//                boxScoreInfo.guestTeamPlayer = getPlayer(withCode:playerCode, fromTeam: guestTeam)
//            }
//        }
//        return boxScoreInfo
//    }
//
//    func getPlayer(withCode playerCode: String, fromTeam team: EBSTeam) -> EBSPlayer? {
//        guard let players = team.players else {
//            return nil
//        }
//        for player in players where player.code == playerCode {
//            return player
//        }
//        return nil
//    }
//
//}
//
struct BoxScoreInfo {
    var name: String = ""
    var homeTeamPlayerName: String = ""
    var guestTeamPlayerName: String = ""
    var homeTeamPlayerPointText: String = ""
    var guestTeamPlayerPointText: String = ""
    var homeTeamPlayer: Player?
    var guestTeamPlayer: Player?
}
