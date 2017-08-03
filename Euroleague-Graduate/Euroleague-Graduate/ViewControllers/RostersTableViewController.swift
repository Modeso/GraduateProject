//
//  RostersTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/3/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RostersTableViewController: UIViewController , IndicatorInfoProvider{

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "ROSTER"
    }

}
