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

class TurkishLeaguePagerViewController: ButtonBarPagerTabStripViewController {
    
    fileprivate var myViewControllers: Array<TurkishLeagueMasterTableViewController> = []
    
    fileprivate let viewModel = TurkishLeagueViewModel()
    
    private let barColor = UIColor(red: 255.0/255, green: 88.0/255, blue: 4.0/255, alpha: 1)
    
    fileprivate var refreshing = true
    
    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = barColor
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = UIFont(name: "CoText-Regular", size: 13.0)!
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = barColor
        navigationController?.navigationBar.isTranslucent = false
        let navImage = UIImage(named: "navbar-turkishairlines")
        let navImageView = UIImageView(image: navImage)
        navImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = navImageView
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        self.buttonBarView.collectionViewLayout
            .collectionView?.backgroundColor = barColor
        
        self.containerView.backgroundColor = UIColor(patternImage: UIImage(named: "TurkishLeagueBackGround")!)
        
        self.edgesForExtendedLayout = []
        
    }
    
    private func createControllers() {
        let router = TurkishLeagueGamesRouter()
        let regularSeasonController = router.createTurkishLeagueTableController(indentifier: "TurkishLeagueMasterTable")
        let playOffSeasonController = router.createTurkishLeagueTableController(indentifier: "TurkishLeagueMasterTable")
        let finalFourSeasonController = router.createTurkishLeagueTableController(indentifier: "TurkishLeagueMasterTable")
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
        viewModel.getData()
        refreshing = true
        return myViewControllers
    }
    
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

extension TurkishLeaguePagerViewController: GameDataViewModelDelegate {
    
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

extension TurkishLeaguePagerViewController: PagerUpdateDelegate {
    
    func getUpdatedData() {
        refreshing = true
        viewModel.updateData()
    }
    
    func isRefreshing() -> Bool {
        return refreshing
    }
}

extension Date {
    
    func convertStringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: date)!
    }
    
    func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
}
