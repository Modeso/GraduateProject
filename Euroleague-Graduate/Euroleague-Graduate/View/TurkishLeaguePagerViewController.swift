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
    func updateUIWithData(_ table: [Array<GameData>])
    func getRound() -> String
}

protocol PagerUpdateDelegate {
    func getUpdatedData()
    func isResreshing() -> Bool
}

class TurkishLeaguePagerViewController: ButtonBarPagerTabStripViewController,
UISplitViewControllerDelegate, GameDataViewModelDelegate, PagerUpdateDelegate {
    
    private var myViewControllers: Array<UITableViewController> = []
    
    private let viewModel = TurkishLeagueViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    private var isRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.buttonBarBackgroundColor = UIColor.orange
        settings.style.buttonBarItemBackgroundColor = UIColor.orange
        settings.style.selectedBarBackgroundColor = UIColor.orange
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Light", size:14) ?? UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
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
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if secondaryViewController.contents
                is TurkishLeagueGameDetailViewController {
                return true
            }
        }
        return false
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createControllers()
        viewModel.delegate = self
        viewModel.getData()
        return myViewControllers
    }
    
    func updateControllersData(_ table: Dictionary<String, [Array<GameData>]>) {
        for controller in myViewControllers {
            let newController = controller as? PagerUpdateChildData
            newController?.updateUIWithData(table[(newController?.getRound())!]!)
        }
        isRefreshing = false
    }
    
    func getUpdatedData() {
        isRefreshing = true
        viewModel.getData()
    }
    
    func isResreshing() -> Bool {
        return isRefreshing
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
