//
//  LeaguesCommenObjects.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/18/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit

public class Constants {

    public static let BackGroundColor: UIColor = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1)

    public static var season: Season = Season.turkishEuroLeague

    public enum Season {
        case turkishEuroLeague
        case euroCup

        public func getSeasonCode() -> String {
            switch self {
            case .turkishEuroLeague:
                return "E2016"
            case .euroCup:
                return "U2016"
            }
        }

        public func getColor() -> UIColor {
            switch self {
            case .turkishEuroLeague:
                return UIColor(red: 255.0/255, green: 88.0/255, blue: 4.0/255, alpha: 1)
            case .euroCup:
                return UIColor(red: 0.0/255, green: 114.0/255, blue: 206.0/255, alpha: 1)
            }
        }

        public func getColoredImage() -> UIImage {
            switch self {
            case .turkishEuroLeague:
                if let image = UIImage(named: "el-color") {
                    return image
                }
                return UIImage()
            case .euroCup:
                if let image = UIImage(named: "ec-color") {
                    return image
                }
                return UIImage()
            }
        }

        public func getNonColoredImage() -> UIImage {
            switch self {
            case .turkishEuroLeague:
                if let image = UIImage(named: "el-nocolor") {
                    return image
                }
                return UIImage()
            case .euroCup:
                if let image = UIImage(named: "ec-nocolor") {
                    return image
                }
                return UIImage()
            }
        }

        public func getNavImage() -> UIImage {
            switch self {
            case .turkishEuroLeague:
                if let image = UIImage(named: "el-navbar") {
                    return image
                }
                return UIImage()
            case .euroCup:
                if let image = UIImage(named: "ec-navbar") {
                    return image
                }
                return UIImage()
            }
        }

        public func getRounds() -> [LeagueRound] {
            let rounds: [LeagueRound]
            switch self {
            case .turkishEuroLeague:
                rounds = [
                    LeagueRound(name: "RS", barName: "RS", completeName: "Regular Season", priority: 3),
                    LeagueRound(name: "PO", barName: "PO", completeName: "Play Offs", priority: 2),
                    LeagueRound(name: "FF", barName: "F4", completeName: "Final Four", priority: 1)
                ]
                return rounds
            case .euroCup:
                rounds = [
                    LeagueRound(name: "RS", barName: "RS", completeName: "Regular Season", priority: 5),
                    LeagueRound(name: "TS", barName: "T16", completeName: "Top 16", priority: 4),
                    LeagueRound(name: "4F", barName: "QF", completeName: "Quarter Final", priority: 3),
                    LeagueRound(name: "2F", barName: "SF", completeName: "Semi final", priority: 2),
                    LeagueRound(name: "Final", barName: "F", completeName: "Final", priority: 1)]
                return rounds
            }
        }

        public func getTeamStatisticsMenuOptions() -> [Int: LeagueRound] {
            var menu: [Int: LeagueRound] = [:]
            let rounds = getRounds()
            var counter = 2
            var priority = rounds.count
            menu[1] = LeagueRound(name: "", barName: "", completeName: "All phases", priority: priority + 1)
            for round in rounds {
                menu[counter] = LeagueRound(name: round.name, barName: round.barName, completeName: round.completeName, priority: round.priority)
            }
            return menu
        }
    }

}

public struct LeagueRound {

    public var name: String
    public var barName: String
    public var completeName: String
    public var priority: Int

    public init() {
        name = ""
        barName = ""
        completeName = ""
        priority = 0
    }

    public init(name: String, barName: String, completeName: String, priority: Int) {
        self.name = name
        self.barName = barName
        self.completeName = completeName
        self.priority = priority
    }
}
