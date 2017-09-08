//
//  GameDetailViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/25/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EuroLeagueKit

class GameDetailViewController: ButtonBarPagerTabStripViewController {

    var game: Game?

    fileprivate var myViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        if let font = UIFont(name: "CoText-Regular", size: 13.0) {
            settings.style.buttonBarItemFont = font
        }
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemBackgroundColor = UIColor.getLeagueBarColor()
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true

        super.viewDidLoad()
        buttonBarView.backgroundColor = UIColor.getLeagueBarColor()
        self.edgesForExtendedLayout = []
        if let image = UIImage(named: "LeagueBackGround") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }

    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        createViewControllers()
        return myViewControllers
    }

}

fileprivate extension GameDetailViewController {

    func createViewControllers() {
        let router = Router()
        let boxScore = router.createGameBoxScore()
        boxScore.game = game
        myViewControllers.append(boxScore)
        guard  let gameNumber = game?.gameNumber
            else { return }
        let playByPlay = router.createGameDetailWebViewController()
        playByPlay.name = "PLAY BY PLAY"
        playByPlay.urlString = createWebViewUrl(type: "pbpmobile", gameCode: gameNumber, season: Constants.season.getSeasonCode())
        let shootingChart = router.createGameDetailWebViewController()
        shootingChart.name = "SHOOTING CHART"
        shootingChart.urlString = createWebViewUrl(type: "shootingchart", gameCode: gameNumber, season: Constants.season.getSeasonCode())
        let gameEvolution = router.createGameDetailWebViewController()
        gameEvolution.name = "GAME EVOLUTION"
        gameEvolution.urlString = createWebViewUrl(type: "graphic", gameCode: gameNumber, season: Constants.season.getSeasonCode())
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
