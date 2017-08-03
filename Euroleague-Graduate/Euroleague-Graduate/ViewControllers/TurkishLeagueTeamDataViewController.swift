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
    
    var team: Team?
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var tvCodeLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = Colors.TurkishLeagueBarColor
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = UIFont(name: "CoText-Regular", size: 14.0)!
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.automaticallyAdjustsScrollViewInsets = false
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = Colors.TurkishLeagueBarColor
        navigationController?.navigationBar.isTranslucent = false
        let navImage = UIImage(named: "navbar-turkishairlines")
        let navImageView = UIImageView(image: navImage)
        navImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = navImageView
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        self.buttonBarView.collectionViewLayout
            .collectionView?.backgroundColor = Colors.TurkishLeagueBarColor
        
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
        guard let team = self.team else { return }
        teamNameLabel.text = team.name
        tvCodeLabel.text = team.tvCode
        countryLabel.text = team.countryName
        teamImageView?.sd_setImage(with: URL(string:team.logoUrl), placeholderImage: UIImage(named: "emptyImage"))
    }
    
    func createControllers() {
        let router = TurkishLeagueGamesRouter()
        let roster = router.createTurkishLeagueRosterTableController()
        myViewControllers.append(roster)
    }
}
