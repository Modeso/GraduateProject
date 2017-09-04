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

protocol PagerUpdateChildData {
    func updateUIWithData(_ table: [Array<Game>], lastGameIndex: (section: Int, row: Int))
    func getRound() -> String
}

protocol PagerUpdateDelegate: class {
    func getUpdatedData()
    func isRefreshing() -> Bool
}

class GamesPagerViewController: ButtonBarPagerTabStripViewController {

    fileprivate var myViewControllers: Array<MasterTableViewController> = []

    fileprivate let viewModel = GamesViewModel(season: LeaguesCommenObjects.season)

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
        viewModel.delegate = self

        super.viewDidLoad()

        buttonBarView.backgroundColor = UIColor.getLeagueBarColor()
        self.edgesForExtendedLayout = []
        if let image = UIImage(named: "LeagueBackGround") {
            self.view.backgroundColor = UIColor(patternImage: image)

        }
    }

    deinit {
        print("deinit GamesPagerViewController")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.delegate = nil

    }
    private func createControllers() {
        let router = Router()
        let rounds = LeaguesCommenObjects.season.getRounds()
        for round in rounds {
            let roundViewController = router.createLeagueGameTableController()
            roundViewController.round = round
            myViewControllers.append(roundViewController)
        }
        for controller in myViewControllers {
            controller.pagerDelegate = self
        }

    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createControllers()
        viewModel.getGamesData()
        refreshing = true
        return myViewControllers
    }

}

extension GamesPagerViewController: GameDataViewModelDelegate {

    func updateControllersData(_ table: Dictionary<String, [Array<Game>]>,
                               lastPlayedGames: Dictionary<String, (section: Int, row: Int)>) {
        for controller in myViewControllers {
            if let lastGameIndex =  lastPlayedGames[controller.getRound()],
                let schedule = table[controller.getRound()] {
                controller.updateUIWithData(
                    schedule,
                    lastGameIndex: lastGameIndex)
            }

        }
        refreshing = false
    }

}

extension GamesPagerViewController: PagerUpdateDelegate {

    // pull down to refresh..
    func getUpdatedData() {
        refreshing = true
        viewModel.updateData()
    }

    func isRefreshing() -> Bool {
        return refreshing
    }
}
