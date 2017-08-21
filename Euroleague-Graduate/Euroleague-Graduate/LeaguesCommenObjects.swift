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
    
    static var season: Season = Season.TurkishAirLinesEuroLeague
    
    enum Season {
        case TurkishAirLinesEuroLeague
        case EuroCup
        
        func values() -> (season: String, color: UIColor, image: UIImage, navImage: UIImage) {
            let season: String
            let color: UIColor
            var image = UIImage()
            var navImage = UIImage()
            switch self {
            case .TurkishAirLinesEuroLeague:
                season = "E2016"
                color = UIColor(red: 244.0/255, green: 84.0/255, blue: 2.0/255, alpha: 1)
                if let img = UIImage(named: "el-color") {
                    image = img
                }
                if let img = UIImage(named: "el-navbar") {
                    navImage = img
                }
            case .EuroCup:
                season = "U2016"
                color = UIColor(red: 0.0/255, green: 114.0/255, blue: 206.0/255, alpha: 1)
                if let img = UIImage(named: "ec-color") {
                    image = img
                }
                if let img = UIImage(named: "ec-navbar") {
                    navImage = img
                }
            }
            return (season, color, image, navImage)
        }
        
        func getSeasonCode() -> String {
            switch self {
            case .TurkishAirLinesEuroLeague:
                return "E2016"
            case .EuroCup:
                return "U2016"
            }
        }
        
        func getColor() -> UIColor {
            switch self {
            case .TurkishAirLinesEuroLeague:
                return UIColor(red: 255.0/255, green: 88.0/255, blue: 4.0/255, alpha: 1)
            case .EuroCup:
                return UIColor(red: 0.0/255, green: 114.0/255, blue: 206.0/255, alpha: 1)
            }
        }
        
        func getImage() -> UIImage {
            switch self {
            case .TurkishAirLinesEuroLeague:
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
        
        func getNavImage() -> UIImage {
            switch self {
            case .TurkishAirLinesEuroLeague:
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
    }
    
}
