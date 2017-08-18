//
//  LeaguesCommenObjects.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/18/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

class LeaguesCommenObjects {
    
    static var season: String = Season.TurkishAirLinesEuroLeague.rawValue
    
//    static var baseUrl = BaseUrlType.normal.rawValue
    
    enum Season: String {
        case TurkishAirLinesEuroLeague = "E2016"
        case EuroCup = "U2016"
    }
    
//    enum BaseUrlType: String {
//        case normal = "http://www.euroleague.net/euroleague/api/"
//        case web = "http://live.euroleague.net/"
//    }
    
}
