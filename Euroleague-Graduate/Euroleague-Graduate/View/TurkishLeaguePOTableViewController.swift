//
//  TurkishLeaguePOTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TurkishLeaguePOTableViewController: TurkishLeagueMasterTableViewController{
    
    private let round = "PO"
    
    override func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: round)
    }
    
    override func getRound() -> String {
        return round
    }
}
