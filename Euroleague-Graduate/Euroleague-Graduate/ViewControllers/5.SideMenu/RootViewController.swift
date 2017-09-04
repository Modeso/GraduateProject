//
//  RootViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/16/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import AKSideMenu


class RootViewController: AKSideMenu, AKSideMenuDelegate {

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.lightContent
        self.contentViewShadowColor = UIColor.black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true

        if let season = UserDefaults.standard.value(forKey: "CurrentSeason") as? String {
            switch season {
            case Constants.Season.TurkishEuroLeague.getSeasonCode():
                Constants.season = Constants.Season.TurkishEuroLeague
            case Constants.Season.EuroCup.getSeasonCode():
                Constants.season = Constants.Season.EuroCup
            default:
                Constants.season = Constants.Season.TurkishEuroLeague
            }
            self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "GamesContentNavigationController")
            self.leftMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController")

            self.delegate = self
        }

    }

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

}
