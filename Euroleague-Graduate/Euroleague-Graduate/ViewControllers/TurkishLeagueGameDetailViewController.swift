//
//  TurkishLeagueGameDetailViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/25/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TurkishLeagueGameDetailViewController: ButtonBarPagerTabStripViewController {
    
    var game: Game?
    
    fileprivate var myViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        settings.style.buttonBarItemFont = UIFont(name: "CoText-Regular", size: 13.0)!
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemBackgroundColor = UIColor.getTurkishLeagueBarColor()
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "TurkishLeagueBackGround")!)
        
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createViewControllers()
        return myViewControllers
    }

}

fileprivate extension TurkishLeagueGameDetailViewController {
    
    func createViewControllers() {
        let router = TurkishLeagueGamesRouter()
        let boxScore = router.createGameBoxScore()
        boxScore.game = game
        myViewControllers.append(boxScore)
        guard  let gameNumber = game?.gameNumber
            else { return }
        let playByPlay = router.createGameDetailWebViewController()
        playByPlay.name = "PLAY BY PLAY"
        playByPlay.urlString = createWebViewUrl(type: "pbpmobile", gameCode: gameNumber, season: LeaguesCommenObjects.season)
        let shootingChart = router.createGameDetailWebViewController()
        shootingChart.name = "SHOOTING CHART"
        shootingChart.urlString = createWebViewUrl(type: "shootingchart", gameCode: gameNumber, season: LeaguesCommenObjects.season)
        let gameEvolution = router.createGameDetailWebViewController()
        gameEvolution.name = "GAME EVOLUTION"
        gameEvolution.urlString = createWebViewUrl(type: "graphic", gameCode: gameNumber, season: LeaguesCommenObjects.season)
        myViewControllers.append(shootingChart)
        myViewControllers.append(gameEvolution)
        myViewControllers.append(playByPlay)
    }
    
    func createWebViewUrl(type: String, gameCode: Int, season: String) -> String {
        var url = "http://live.euroleague.net/"
        url.append("\(type)/?")
        url.append("gamecode=\(gameCode)&seasoncode=\(season)")
        return url
    }
    
}
