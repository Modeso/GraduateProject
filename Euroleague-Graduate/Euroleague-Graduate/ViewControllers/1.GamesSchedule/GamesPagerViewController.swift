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
    func updateUIWithData(_ table: [Array<Game>]?, lastGameIndex: (section: Int, row: Int)?)
    func getRound() -> String
}

class GamesPagerViewController: ButtonBarPagerTabStripViewController {

    fileprivate var myViewControllers: Array<MatchesTableViewController> = []

    fileprivate let viewModel = GamesViewModel(season: Constants.season)

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
        let rounds = Constants.season.getRounds()
        for round in rounds {
            let roundViewController = Router.createLeagueGameTableController()
            roundViewController.round = round
            myViewControllers.append(roundViewController)
        }
        for controller in myViewControllers {
            controller.delegate = self
        }

    }

}

extension GamesPagerViewController: UpdateRoundDataDelegate {

    func getDataToShow(ofRound round: String, completion: ([[Game]], (section: Int, row: Int)) -> Void) {
        viewModel.getData(withData: [round]) { schedule in
            for controller in self.myViewControllers {
                if controller.round.round == round {
                    if let games = schedule as? [[Game]],
                        let lastGame = self.viewModel.getLastGame(round: round) {
                        if Thread.isMainThread {
                            controller.updateUIWithData(games, lastGameIndex: lastGame)
                        } else {
                            DispatchQueue.main.async {
                                controller.updateUIWithData(games, lastGameIndex: lastGame)
                            }
                        }
                    }
                    break
                }
            }
        }
    }

    // pull down to refresh..
    func getUpdatedData(ofRound round: String) {
        refreshing = true
        viewModel.updateData(withData: round) { schedule in
            for controller in self.myViewControllers {
                if controller.round.round == round {
                    self.refreshing = false
                    print("completion refreshing finish round \(round)")
                    if let games = schedule as? [[Game]],
                        let lastGame = self.viewModel.getLastGame(round: round) {
                        if Thread.isMainThread {
                            controller.updateUIWithData(games, lastGameIndex: lastGame)
                        } else {
                            DispatchQueue.main.async {
                                controller.updateUIWithData(games, lastGameIndex: lastGame)
                            }
                        }
                    } else {
                        controller.updateUIWithData(nil, lastGameIndex: nil)
                    }
                    break
                }
            }
        }
    }

    func isRefreshing() -> Bool {
        return refreshing
    }
}
