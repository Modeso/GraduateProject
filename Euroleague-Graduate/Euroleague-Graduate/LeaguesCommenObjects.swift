//
//  LeaguesCommenObjects.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/18/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit

class LeaguesCommenObjects {
    
    static let BackGroundColor: UIColor = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1)
    
    static var season: Season = Season.turkishEuroLeague
    
    enum Season {
        case turkishEuroLeague
        case euroCup
        
        func values() -> (season: String, color: UIColor, coloredImage: UIImage,
            unColoredImage: UIImage, navImage: UIImage, rounds: [(round: String, name: String, completeName: String)]) {
            let season: String = getSeasonCode()
            let color: UIColor = getColor()
            let coloredImage = getColoredImage()
            let unColoredImage = getNonColoredImage()
            let navImage = getNavImage()
            let rounds = getRounds()
            return (season, color, coloredImage, unColoredImage, navImage, rounds)
        }
        
        func getSeasonCode() -> String {
            switch self {
            case .turkishEuroLeague:
                return "E2016"
            case .euroCup:
                return "U2016"
            }
        }
        
        func getColor() -> UIColor {
            switch self {
            case .turkishEuroLeague:
                return UIColor(red: 255.0/255, green: 88.0/255, blue: 4.0/255, alpha: 1)
            case .euroCup:
                return UIColor(red: 0.0/255, green: 114.0/255, blue: 206.0/255, alpha: 1)
            }
        }
        
        func getColoredImage() -> UIImage {
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
        
        func getNonColoredImage() -> UIImage {
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
        
        func getNavImage() -> UIImage {
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
        
        func getRounds() -> [(round: String, name: String, completeName: String)] {
            let rounds: [(round: String, name: String, completeName: String)]
            switch self {
            case .turkishEuroLeague:
                rounds = [
                    ("RS", "RS", "Regular Season"),
                    ("PO", "PO", "Play Offs"),
                    ("FF", "F4", "Final Four")
                ]
                return rounds
            case .euroCup:
                rounds = [
                    ("RS", "RS", "Regular Season"),
                    ("TS", "T16", "Top 16"),
                    ("4F", "QF", "Quarter Final"),
                    ("2F", "SF", "Semi final"),
                    ("Final", "F", "Final")]
                return rounds
            }
        }
        
        func getTeamStatisticsMenuOptions() -> Dictionary<Int, (text: String, priority: Int, round: String)> {
            var menu: Dictionary<Int,(text: String, priority: Int, round: String)> = [:]
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
