//
//  TurkishLeagueF4TableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TurkishLeagueFFTableViewController: TurkishLeagueMasterTableViewController{
    
    private let round = "FF"
    
    override func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "F4")
    }
    
    override func getRound() -> String {
        return round
    }
}
