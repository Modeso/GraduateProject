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
GameDataViewModelDelegate, PagerUpdateDelegate {
    
    private var myViewControllers: Array<UITableViewController> = []
    
    private let viewModel = TurkishLeagueViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private var isRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.style.buttonBarBackgroundColor = UIColor(red: 238.0/255, green: 62.0/255, blue: 8.0/255, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 238.0/255, green: 62.0/255, blue: 8.0/255, alpha: 1)
        settings.style.selectedBarBackgroundColor = UIColor(red: 238.0/255, green: 62.0/255, blue: 8.0/255, alpha: 1)
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        self.buttonBarView.collectionViewLayout
            .collectionView?.backgroundColor = UIColor(red: 238.0/255, green: 62.0/255, blue: 8.0/255, alpha: 1)
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
    
    func updateControllersData(_ table: Dictionary<String, [Array<GameData>]>) {
        for controller in myViewControllers {
            let newController = controller as? PagerUpdateChildData
            newController?.updateUIWithData(table[(newController?.getRound())!]!)
        }
        isRefreshing = false
    }
    
    func getUpdatedData() {
        isRefreshing = true
        viewModel.updateData()
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
