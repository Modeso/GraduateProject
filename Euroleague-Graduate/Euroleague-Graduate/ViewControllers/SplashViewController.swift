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

class SplashViewController: UIViewController {
    
    fileprivate var player = AVPlayer()
    
    @IBOutlet weak var playerView: UIView!

    @IBOutlet weak var turkishLeagueView: UIView!
    
    @IBOutlet weak var euroCupView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        if (UserDefaults.standard.value(forKey: "CurrentSeason") as? String) != nil {
//            performSegue(withIdentifier: "ShowMainScreen", sender: self)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.value(forKey: "CurrentSeason") as? String) != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "RootViewController")
            self.present(controller, animated: true, completion: nil)
        }
        else{
            turkishLeagueView.applyGradient(colours: [UIColor.black, UIColor.clear])
            euroCupView.applyGradient(colours: [UIColor.black, UIColor.clear])
            playVideo()
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if (UserDefaults.standard.value(forKey: "CurrentSeason") as? String) != nil {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "RootViewController")
//            self.present(controller, animated: true, completion: nil)
//        }
    }
    
    @IBAction func LeagueChoosed(recognizer:UITapGestureRecognizer) {
        let season: String
        if let touchedView = recognizer.view {
            switch touchedView {
            case turkishLeagueView:
                season = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getSeasonCode()
                UserDefaults.standard.set(season, forKey: "CurrentSeason")
                performSegue(withIdentifier: "ShowMainScreen", sender: self)
                break
            case euroCupView:
                season = LeaguesCommenObjects.Season.EuroCup.getSeasonCode()
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
        playerLayer.opacity = 0.5
        playerLayer.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.player.seek(to: kCMTimeZero)
        self.player.play()
    }
    
}
