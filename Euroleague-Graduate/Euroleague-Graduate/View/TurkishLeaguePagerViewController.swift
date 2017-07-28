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
    func isResreshing() -> Bool
}

class TurkishLeaguePagerViewController: ButtonBarPagerTabStripViewController {
    
    fileprivate var myViewControllers: Array<UITableViewController> = []
    
    fileprivate let viewModel = TurkishLeagueViewModel()
    
    private let barColor = UIColor(red: 238.0/255, green: 62.0/255, blue: 8.0/255, alpha: 1)
    
    fileprivate var isRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = barColor
        navigationController?.navigationBar.backgroundColor = barColor
        navigationController?.navigationBar.isTranslucent = false
        let navImage = UIImage(named: "navbar-turkishairlines")
        let navImageView = UIImageView(image: navImage)
        navImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = navImageView
        
        settings.style.buttonBarBackgroundColor = barColor
        settings.style.buttonBarItemBackgroundColor = barColor
        settings.style.selectedBarBackgroundColor = barColor
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        self.buttonBarView.collectionViewLayout
            .collectionView?.backgroundColor = barColor
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
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
            let newController = controller as? PagerUpdateChildData
            newController?.updateUIWithData(
                table[newController!.getRound()]!,
                lastGameIndex: lastPlayedGames[newController!.getRound()]!)
        }
        isRefreshing = false
    }
    
}

extension TurkishLeaguePagerViewController: PagerUpdateDelegate {
    
    func getUpdatedData() {
        isRefreshing = true
        viewModel.updateData()
    }
    
    func isResreshing() -> Bool {
        return isRefreshing
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
