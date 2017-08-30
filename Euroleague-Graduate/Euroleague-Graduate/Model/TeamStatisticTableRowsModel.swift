//
//  TeamStatisticTableRowsModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/15/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

class TeamStatisticTableRowsModel {

    let rows: [String] = [
        "Games", "Wins", "Points", "2 Points Field Goal %",
        "3 Points Field Goal %", "Free throws %",
        "Rebounds", "Assists", "Steals", "Turnovers",
        "Blocks", "Fouls"
    ]

    var results: Dictionary<String, Float> = [
        "Games" : 0,
        "Wins" : 0,
        "Points" : 0,
        "2 Points Field Goal %" : 0,
        "3 Points Field Goal %" : 0,
        "Free throws %" : 0,
        "Rebounds" : 0,
        "Assists" : 0,
        "Steals" : 0,
        "Turnovers" : 0,
        "Blocks" : 0,
        "Fouls" : 0
    ]

    fileprivate var currentRound: String = ""

    func getDataAccordingToMenu(round: String) {
        // Just making fake data
        var max: Float = 0
        switch round {
        case "RS":
            max = 800
        case "PO":
            max = 600
        case "FF":
            max = 400
        default:
            max = 1000
        }
        for result in results {
            results[result.key] = Float.random(min: 5, max: max)
        }
    }

}

fileprivate extension TeamStatisticTableRowsModel {

}
