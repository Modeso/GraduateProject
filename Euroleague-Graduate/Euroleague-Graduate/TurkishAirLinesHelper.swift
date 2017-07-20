//
//  TurkishAirLinesHelper.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/19/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

class TurkishAirLinesHelper {
    
    enum GameDataStatus {
        case schedule
        case results
    }
    
    let urls: Dictionary<GameDataStatus, String> = [
        .schedule : "http://www.euroleague.net/euroleague/api/schedules?seasoncode=E2016",
        .results : "http://www.euroleague.net/euroleague/api/results?seasoncode=E2016"
    ]
    
    func getGamesTable() {
        getSchedule()
    }
    
    private func getSchedule() {
        TurkishAirlinesApiClient
            .getRequestFrom(
                url: urls[.schedule]!,
                parameters: [:],
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        
                        self?.getResults()
                    }
                    else{
                        
                    }
        }
    }
    
    private func getResults() {
        TurkishAirlinesApiClient
            .getRequestFrom(
                url: urls[.schedule]!,
                parameters: [:],
                headers: [:]){ [weak self] data ,error in
                    if let xmlData = data, error == nil {
                        
                        self?.makingTableData()
                    }
                    else{
                        
                    }
        }
    }
    
    private func makingTableData() {
        
    }
    
}
