//
//  TurkishLeagueGamesRouter.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/1/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Router {
    
    func createLeagueGameTableController () -> MasterTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableController = storyboard.instantiateViewController(
            withIdentifier: "TurkishLeagueMasterTable") as? MasterTableViewController
            else { return MasterTableViewController() }
        return tableController
    }
    
    func createRosterTableController () -> RostersTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableController = storyboard.instantiateViewController(
            withIdentifier: "RostersTable") as? RostersTableViewController
            else { return RostersTableViewController() }
        return tableController
    }
    
    func createTeamStatistics() -> TeamStatisticsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "StatisticsView") as? TeamStatisticsViewController
            else { return TeamStatisticsViewController() }
        return view
    }
    
    func createGameBoxScore() -> GameBoxScoreViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "GameBoxScore") as? GameBoxScoreViewController
            else { return GameBoxScoreViewController() }
        return view
    }
    
    func createGameDetailWebViewController() -> GameDetailMasterWebViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "GameDetailWebViewController") as? GameDetailMasterWebViewController
            else { return GameDetailMasterWebViewController() }
        return view
    }
    
}
