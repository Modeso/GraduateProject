//
//  GamesPagerViewController.swift
//  Euroleague-Graduate
//
//  Created by Mohammed Elsammak on 7/7/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip
import EuroLeagueKit

protocol PagerUpdateChildData {
    func updateUIWithData(_ games: [Game])
    func getRound() -> String
}

class GamesPagerViewController: ButtonBarPagerTabStripViewController {

    fileprivate var myViewControllers: [MatchesTableViewController] = []
    fileprivate let gamesViewModel = GamesPagerViewModel(season: Constants.season)
    fileprivate var isRefreshing = true

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
        gamesViewModel.getData(withData: nil) { [weak self] schedule in
            guard let schedule = schedule as? [Game],
            let myViewControllers = self?.myViewControllers,
            schedule.count > 0 else { return }
            for matchesController in myViewControllers {
                if schedule.contains(where: { $0.round == matchesController.getRound() }) {
                    let games = schedule.filter({ $0.round == matchesController.getRound() })
                    matchesController.updateUIWithData(games)
                }
            }
        }
        buttonBarView.backgroundColor = UIColor.getLeagueBarColor()
        self.edgesForExtendedLayout = []
        if let image = UIImage(named: "LeagueBackGround") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createControllers()
        isRefreshing = false
        return myViewControllers
    }

}

fileprivate extension GamesPagerViewController {

    func createControllers() {
        let router = Router()
        let rounds = Constants.season.getRounds()
        for round in rounds {
            let roundViewController = router.createLeagueGameTableController()
            roundViewController.round = round
            myViewControllers.append(roundViewController)
        }
        for controller in myViewControllers {
            controller.delegate = self
        }
    }

}

extension GamesPagerViewController: UpdateRoundDataDelegate {

    // pull down to refresh..
    func getUpdatedData(ofRound round: String) {
        isRefreshing = true
        gamesViewModel.updateData(withData: round) { [weak self] schedule in
            self?.isRefreshing = false
            guard let schedule = schedule as? [Game] else { return }
            let matchesController = self?.myViewControllers.first(where: { $0.getRound() == round })
            matchesController?.updateUIWithData(schedule.filter({ $0.round == matchesController?.getRound() }))
        }
    }

    func isPagerRefreshing() -> Bool {
        return isRefreshing
    }

}
