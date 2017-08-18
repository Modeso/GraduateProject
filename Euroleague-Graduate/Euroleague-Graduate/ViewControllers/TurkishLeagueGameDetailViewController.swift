//
//  TurkishLeagueGameDetailViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/25/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TurkishLeagueGameDetailViewController: ButtonBarPagerTabStripViewController {
    
    var game: Game?
    
    fileprivate var myViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        settings.style.buttonBarItemFont = UIFont(name: "CoText-Regular", size: 13.0)!
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemBackgroundColor = UIColor.getTurkishLeagueBarColor()
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "TurkishLeagueBackGround")!)
        
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createViewControllers()
        return myViewControllers
    }

}

fileprivate extension TurkishLeagueGameDetailViewController {
    
    func createViewControllers() {
        let router = TurkishLeagueGamesRouter()
        let boxScore = router.createGameBoxScore()
        boxScore.game = game
        myViewControllers.append(boxScore)
    }
}
