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
    func updateUIWithData(_ table: [Array<GameData>], lastGameIndex: (section: Int, row: Int))
    func getRound() -> String
}

protocol PagerUpdateDelegate {
    func getUpdatedData()
    func isRefreshing() -> Bool
}

class TurkishLeaguePagerViewController: ButtonBarPagerTabStripViewController {
    
    fileprivate var myViewControllers: Array<UITableViewController> = []
    
    fileprivate let viewModel = TurkishLeagueViewModel()
    
    private let barColor = UIColor(red: 255.0/255, green: 88.0/255, blue: 4.0/255, alpha: 1)
    
    fileprivate var refreshing = true
    
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = barColor
        navigationController?.navigationBar.isTranslucent = false
        let navImage = UIImage(named: "navbar-turkishairlines")
        let navImageView = UIImageView(image: navImage)
        navImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = navImageView
        
        settings.style.buttonBarItemBackgroundColor = barColor
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = UIFont(name: "CoText-Regular", size: 13.0)!
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        super.viewDidLoad()
        self.buttonBarView.collectionViewLayout
            .collectionView?.backgroundColor = barColor
        self.edgesForExtendedLayout = []
    }
    
    private func createControllers() {
        myViewControllers.append(TurkishLeagueRegularSeosonTableViewController())
        myViewControllers.append(TurkishLeaguePOTableViewController())
        myViewControllers.append(TurkishLeagueFFTableViewController())
        for controller in myViewControllers {
            let newController = controller as? TurkishLeagueMasterTableViewController
            newController?.pagerDelegate = self
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createControllers()
        viewModel.delegate = self
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
    
    func updateControllersData(_ table: Dictionary<String, [Array<GameData>]>,
                               lastPlayedGames: Dictionary<String, (section: Int, row: Int)>) {
        for controller in myViewControllers {
            if let newController = controller as? PagerUpdateChildData,
                let lastGameIndex =  lastPlayedGames[newController.getRound()],
                let schedule = table[newController.getRound()] {
                newController.updateUIWithData(
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
