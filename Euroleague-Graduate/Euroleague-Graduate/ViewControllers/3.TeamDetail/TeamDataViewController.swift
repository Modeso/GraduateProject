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
import EuroLeagueKit

class TeamDataViewController: ButtonBarPagerTabStripViewController {

    fileprivate var myViewControllers: Array<UIViewController> = []

    var team: Team?

    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var tvCodeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!

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
        guard let team = self.team?.clone() else {
            return
        }
        let roster = Router.createRosterTableController()
        if let coach = team.rosters.first?.clone() {
            roster.coach = coach
        }
        roster.makeRostersOf(Array(team.rosters))
        let statistics = Router.createTeamStatistics()
        myViewControllers.append(roster)
        myViewControllers.append(statistics)
    }
}
