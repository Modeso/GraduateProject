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

class TurkishLeagueGamesPagerViewController: ButtonBarPagerTabStripViewController {
    
    fileprivate var myViewControllers: Array<TurkishLeagueMasterTableViewController> = []
    
    fileprivate let viewModel = TurkishLeagueGamesViewModel()
    
    fileprivate var refreshing = true
    
    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = UIColor.getTurkishLeagueBarColor()
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = UIFont(name: "CoText-Regular", size: 13.0)!
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "TurkishLeagueBackGround")!)
    }
    
    private func createControllers() {
        let router = TurkishLeagueGamesRouter()
        let regularSeasonController = router.createTurkishLeagueGameTableController()
        let playOffSeasonController = router.createTurkishLeagueGameTableController()
        let finalFourSeasonController = router.createTurkishLeagueGameTableController()
        regularSeasonController.round = "RS"
        playOffSeasonController.round = "PO"
        finalFourSeasonController.round = "FF"
        myViewControllers.append(regularSeasonController)
        myViewControllers.append(playOffSeasonController)
        myViewControllers.append(finalFourSeasonController)
        
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

extension TurkishLeagueGamesPagerViewController: GameDataViewModelDelegate {
    
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

extension TurkishLeagueGamesPagerViewController: PagerUpdateDelegate {
    
    func getUpdatedData() {
        refreshing = true
        viewModel.updateData()
    }
    
    func isRefreshing() -> Bool {
        return refreshing
    }
}
