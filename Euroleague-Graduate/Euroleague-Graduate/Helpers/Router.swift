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

    static func createLeagueGameTableController () -> MatchesTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableController = storyboard.instantiateViewController(
            withIdentifier: "TurkishLeagueMasterTable") as? MatchesTableViewController
            else { return MatchesTableViewController() }
        return tableController
    }

    static func createRosterTableController () -> RostersTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableController = storyboard.instantiateViewController(
            withIdentifier: "RostersTable") as? RostersTableViewController
            else { return RostersTableViewController() }
        return tableController
    }

    static func createTeamStatistics() -> TeamStatisticsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "StatisticsView") as? TeamStatisticsViewController
            else { return TeamStatisticsViewController() }
        return view
    }

    static func createGameBoxScore() -> GameBoxScoreViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "GameBoxScore") as? GameBoxScoreViewController
            else { return GameBoxScoreViewController() }
        return view
    }

    static func createGameDetailWebViewController() -> GameDetailWebViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "GameDetailWebViewController") as? GameDetailWebViewController
            else { return GameDetailWebViewController() }
        return view
    }

}
