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

protocol PagerUpdateDelegate {
    func getUpdatedData()
    func isRefreshing() -> Bool
}

class GamesPagerViewController: ButtonBarPagerTabStripViewController {
    
    fileprivate var myViewControllers: Array<MasterTableViewController> = []
    
    fileprivate let viewModel = GamesViewModel()
    
    fileprivate var refreshing = true
    
    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = UIColor.getLeagueBarColor()
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = UIFont(name: "CoText-Regular", size: 13.0)!
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
        viewModel.gamesDelegate = self
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
    
    func getUpdatedData() {
        refreshing = true
        viewModel.updateData()
    }
    
    func isRefreshing() -> Bool {
        return refreshing
    }
}
