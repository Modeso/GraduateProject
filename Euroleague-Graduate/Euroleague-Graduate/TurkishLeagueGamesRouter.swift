//
//  TurkishLeagueGamesRouter.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/1/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit

class TurkishLeagueGamesRouter {
    
    func createTurkishLeagueGameTableController () -> TurkishLeagueMasterTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tableController = storyboard.instantiateViewController(
            withIdentifier: "TurkishLeagueMasterTable") as? TurkishLeagueMasterTableViewController
            else { return TurkishLeagueMasterTableViewController() }
        return tableController
    }
}
