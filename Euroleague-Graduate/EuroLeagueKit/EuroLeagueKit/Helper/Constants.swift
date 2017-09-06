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

    public static let backGroundColor: UIColor = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1)

    public static var season: Season = Season.TurkishEuroLeague

    public enum Season {
        case TurkishEuroLeague
        case EuroCup

        public func values() -> (season: String, color: UIColor, coloredImage: UIImage,
            unColoredImage: UIImage, navImage: UIImage, rounds: [(round: String, name: String, completeName: String)]) {
            let season: String = getSeasonCode()
            let color: UIColor = getColor()
            let coloredImage = getColoredImage()
            let unColoredImage = getNonColoredImage()
            let navImage = getNavImage()
            let rounds = getRounds()
            return (season, color, coloredImage, unColoredImage, navImage, rounds)
        }

        public func getSeasonCode() -> String {
            switch self {
            case .TurkishEuroLeague:
                return "E2016"
            case .EuroCup:
                return "U2016"
            }
        }

        public func getColor() -> UIColor {
            switch self {
            case .TurkishEuroLeague:
                return UIColor(red: 255.0/255, green: 88.0/255, blue: 4.0/255, alpha: 1)
            case .EuroCup:
                return UIColor(red: 0.0/255, green: 114.0/255, blue: 206.0/255, alpha: 1)
            }
        }

        public func getColoredImage() -> UIImage {
            switch self {
            case .TurkishEuroLeague:
                if let image = UIImage(named: "el-color") {
                    return image
                }
                return UIImage()
            case .EuroCup:
                if let image = UIImage(named: "ec-color") {
                    return image
                }
                return UIImage()
            }
        }

        public func getNonColoredImage() -> UIImage {
            switch self {
            case .TurkishEuroLeague:
                if let image = UIImage(named: "el-nocolor") {
                    return image
                }
                return UIImage()
            case .EuroCup:
                if let image = UIImage(named: "ec-nocolor") {
                    return image
                }
                return UIImage()
            }
        }

        public func getNavImage() -> UIImage {
            switch self {
            case .TurkishEuroLeague:
                if let image = UIImage(named: "el-navbar") {
                    return image
                }
                return UIImage()
            case .EuroCup:
                if let image = UIImage(named: "ec-navbar") {
                    return image
                }
                return UIImage()
            }
        }

        public func getRounds() -> [(round: String, name: String, completeName: String)] {
            let rounds: [(round: String, name: String, completeName: String)]
            switch self {
            case .TurkishEuroLeague:
                rounds = [
                    ("RS", "RS", "Regular Season"),
                    ("PO", "PO", "Play Offs"),
                    ("FF", "F4", "Final Four")
                ]
                return rounds
            case .EuroCup:
                rounds = [
                    ("RS", "RS", "Regular Season"),
                    ("TS", "T16", "Top 16"),
                    ("4F", "QF", "Quarter Final"),
                    ("2F", "SF", "Semi final"),
                    ("Final", "F", "Final")]
                return rounds
            }
        }

        public func getTeamStatisticsMenuOptions() -> Dictionary<Int, (text: String, priority: Int, round: String)> {
            var menu: Dictionary<Int, (text: String, priority: Int, round: String)> = [:]
            let rounds = getRounds()
            var counter = 2
            var priority = rounds.count
            menu[1] = ("All phases", priority + 1, "")
            for round in rounds {
                menu[counter] = (round.completeName, priority, round.round)
                priority -= 1
                counter += 1
            }
            return menu
        }

    }

}
