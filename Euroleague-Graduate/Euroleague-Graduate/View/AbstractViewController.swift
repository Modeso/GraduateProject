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

class AbstractViewController: ButtonBarPagerTabStripViewController, UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
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
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let detailVC = secondaryViewController.contents
                as? TurkishLeagueGameDetailViewController {
                return true
            }
        }
        return false
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [TurkishLeagueRegularSeosonTableViewController(style: .plain, parentController: self),
                TurkishLeaguePOTableViewController(style: .plain, parentController: self),
                TurkishLeagueFFTableViewController(style: .plain, parentController: self)
                ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            print(segue.identifier)
        }
    }
    
    func cellWasPressed(game: GameData){
        print(game)
        performSegue(withIdentifier: "showDetailSegue", sender: self)
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
