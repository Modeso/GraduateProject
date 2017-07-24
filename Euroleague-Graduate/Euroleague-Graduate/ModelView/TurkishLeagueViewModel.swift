//
//  TurkishLeagueViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

class TurkishLeagueViewModel {
    
    private let helper: TurkishAirLinesHelper
    private var schedule: Results<GameData>? = nil
    
    init() {
        helper = TurkishAirLinesHelper()
        schedule = helper.getGamesTable()
    }
    
    func getDataOfRound(_ round: String) -> [Array<GameData>]? {
        
        return nil
    }
}
