//
//  AbstractViewController.swift
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
    func updateUIWithData(_ table: [[Game]]?, lastGameIndex: (section: Int, row: Int)?)
    func getRound() -> String
}

class GamesPagerViewController: ButtonBarPagerTabStripViewController {

    fileprivate var myViewControllers: [MatchesTableViewController] = []

    fileprivate let gamesViewModel = GamesViewModel(season: Constants.season)
    fileprivate let roundMatchesViewmodel = RoundsMatchesViewModel(season: Constants.season)

    fileprivate var refreshing = true

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
            guard let schedule = schedule as? [Game], let myViewControllers = self?.myViewControllers else { return }
            self?.roundMatchesViewmodel.makeRoundsMatches(from: schedule)
            for matchesController in myViewControllers {
                if let games = self?.roundMatchesViewmodel.getGames(of: matchesController.getRound()),
                    let lastGame = self?.roundMatchesViewmodel.getLastGame(of: matchesController.getRound()) {
                    if Thread.isMainThread {
                        matchesController.updateUIWithData(games, lastGameIndex: lastGame)
                    } else {
                        DispatchQueue.main.async {
                            matchesController.updateUIWithData(games, lastGameIndex: lastGame)
                        }
                    }
                }
            }
        }
        buttonBarView.backgroundColor = UIColor.getLeagueBarColor()
        self.edgesForExtendedLayout = []
        if let image = UIImage(named: "LeagueBackGround") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createControllers()
        refreshing = false
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
        refreshing = true
        gamesViewModel.updateData(withData: round) { [weak self] schedule in
            self?.refreshing = false
            guard let schedule = schedule as? [Game] else { return }
            self?.roundMatchesViewmodel.makeRoundsMatches(from: schedule)
            let matchesController = self?.myViewControllers.first(where: { $0.getRound() == round })
            if let games = self?.roundMatchesViewmodel.getGames(of: round),
                let lastGame = self?.roundMatchesViewmodel.getLastGame(of: round) {
                if Thread.isMainThread {
                    matchesController?.updateUIWithData(games, lastGameIndex: lastGame)
                } else {
                    DispatchQueue.main.async {
                        matchesController?.updateUIWithData(games, lastGameIndex: lastGame)
                    }
                }
            }
        }
    }

    func isRefreshing() -> Bool {
        return refreshing
    }
}
