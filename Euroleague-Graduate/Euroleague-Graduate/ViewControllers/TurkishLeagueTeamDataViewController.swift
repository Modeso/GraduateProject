//
//  TurkishLeagueTeamDataViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage

class TurkishLeagueTeamDataViewController: ButtonBarPagerTabStripViewController {

    fileprivate var myViewControllers: Array<UIViewController> = []
    
    var team = Team()
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var tvCodeLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = UIColor.getTurkishLeagueBarColor()
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = UIFont(name: "CoText-Regular", size: 14.0)!
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "TurkishLeagueBackGround")!)
        self.edgesForExtendedLayout = []
        
        updateUI()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createControllers()
        return myViewControllers
    }
}

fileprivate extension TurkishLeagueTeamDataViewController {
    
    func updateUI() {
        teamNameLabel.text = team.name
        tvCodeLabel.text = team.tvCode
        countryLabel.text = team.countryName
        teamImageView?.sd_setImage(with: URL(string:team.logoUrl), placeholderImage: UIImage(named: "emptyImage"))
    }
    
    func createControllers() {
        let router = TurkishLeagueGamesRouter()
        let roster = router.createTurkishLeagueRosterTableController()
        roster.coach = team.coach!
        roster.makeRostersOf(Array(team.rosters))
        myViewControllers.append(roster)
    }
}
