//
//  SplashViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/28/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import EuroLeagueKit

class SplashViewController: UIViewController {

    @IBOutlet fileprivate weak var playerView: UIView!
    @IBOutlet fileprivate weak var turkishLeagueView: UIView!
    @IBOutlet fileprivate weak var euroCupView: UIView!
    @IBOutlet fileprivate weak var textLabel: UILabel!
    @IBOutlet fileprivate weak var euroCupWidthConstrain: NSLayoutConstraint!
    @IBOutlet fileprivate weak var turkishLeagueViewTraillingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var euroCupViewTraillingConstraint: NSLayoutConstraint!

    fileprivate var player = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        turkishLeagueView.applyGradient(colours: [UIColor.black, UIColor.clear])
        euroCupView.applyGradient(colours: [UIColor.black, UIColor.clear])
        turkishLeagueView.layer.cornerRadius = turkishLeagueView.frame.height / 2
        euroCupView.layer.cornerRadius = euroCupView.frame.height / 2
        playVideo()
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textLabel.isHidden = true
        euroCupWidthConstrain.constant = turkishLeagueView.frame.width
        turkishLeagueViewTraillingConstraint.constant += view.frame.width + 10
        euroCupViewTraillingConstraint.constant -= (euroCupView.frame.width * 2)
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIView.animate(withDuration: 0.3,
                           animations: { [weak self] in
                            self?.turkishLeagueViewTraillingConstraint.constant = -15
                            self?.view.layoutIfNeeded()
            }) { [weak self] (_) in
                UIView.animate(withDuration: 0.3,
                               animations: { [weak self] in
                                self?.euroCupViewTraillingConstraint.constant = -15
                                self?.view.layoutIfNeeded()
                }) { [weak self] (_) in
                    self?.textLabel.isHidden = false
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }

    @IBAction func leagueChoosed(recognizer: UITapGestureRecognizer) {
        let season: String
        if let touchedView = recognizer.view {
            switch touchedView {
            case turkishLeagueView:
                season = Constants.Season.turkishEuroLeague.getSeasonCode()
                UserDefaults.standard.set(season, forKey: "CurrentSeason")
                performSegue(withIdentifier: "ShowMainScreen", sender: self)
                break
            case euroCupView:
                season = Constants.Season.euroCup.getSeasonCode()
                UserDefaults.standard.set(season, forKey: "CurrentSeason")
                performSegue(withIdentifier: "ShowMainScreen", sender: self)
                break
            default:
                break
            }
        }
    }

}

fileprivate extension SplashViewController {

    func playVideo() {
        guard let path = Bundle.main.path(forResource: "Euroleague-Vid", ofType:"mp4") else {
            print("Euroleague-Vid.mp4 not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer)
        player.play()
    }

    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.player.seek(to: kCMTimeZero)
        self.player.play()
    }

}
