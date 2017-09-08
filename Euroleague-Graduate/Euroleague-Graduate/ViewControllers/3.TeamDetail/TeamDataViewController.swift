//
//  TeamDataViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage
import EuroLeagueKit

class TeamDataViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet fileprivate weak var teamImageView: UIImageView!
    @IBOutlet fileprivate weak var teamNameLabel: UILabel!
    @IBOutlet fileprivate weak var tvCodeLabel: UILabel!
    @IBOutlet fileprivate weak var countryLabel: UILabel!

    fileprivate var myViewControllers: [UIViewController] = []

    var team: Team?

    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = UIColor.getLeagueBarColor()
        settings.style.selectedBarBackgroundColor = UIColor.white
        if let font = UIFont(name: "CoText-Regular", size: 13.0) {
            settings.style.buttonBarItemFont = font
        }
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true

        super.viewDidLoad()
        if let image = UIImage(named: "LeagueBackGround") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        self.edgesForExtendedLayout = []
        containerView.backgroundColor = UIColor.clear
        updateUI()
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createControllers()
        return myViewControllers
    }

}

fileprivate extension TeamDataViewController {

    func updateUI() {
        teamNameLabel.text = team?.name
        tvCodeLabel.text = team?.tvCode
        countryLabel.text = team?.countryName
        if let url = team?.logoUrl {
            teamImageView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "emptyImage"))
        }
    }

    func createControllers() {
        let router = Router()
        guard let team = self.team?.clone() else {
            return
        }
        let roster = router.createRosterTableController()
        roster.setUpPlayers(Array(team.rosters))
        let statistics = router.createTeamStatistics()
        myViewControllers.append(roster)
        myViewControllers.append(statistics)
    }
}
