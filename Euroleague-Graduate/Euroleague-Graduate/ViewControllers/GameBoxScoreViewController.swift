//
//  GameBoxScoreViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/17/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class GameBoxScoreViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var awayImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var browserButton: UIButton!
    
    fileprivate let boxScoreViewModel = BoxScoreViewModel(season: LeaguesCommenObjects.season)
    
    var game: Game? {
        didSet{
            updateUI()
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "BOXSCORE"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxScoreViewModel.delegate = self
        browserButton.backgroundColor = LeaguesCommenObjects.season.getColor()
        collectionViewHeightConstrain.constant = 0
        tableViewHeightConstrain.constant = 0
        collectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old.union(NSKeyValueObservingOptions.new), context: nil)
        
        if let code = game?.gameCode {
            boxScoreViewModel.getGameDetail(ofGameWithCode: code)
        }
        
        // CollectionView Settings
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        
        // TableView Settings
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateUI()
        self.view.layoutIfNeeded()
        DispatchQueue.main.async {
            self.collectionViewHeightConstrain.constant = self.collectionView.contentSize.height
        }
        self.tableView.reloadData()
        DispatchQueue.main.async {
            self.tableViewHeightConstrain.constant = self.tableView.contentSize.height
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            self.collectionViewHeightConstrain.constant = self.collectionView.contentSize.height
        }
    }
    
    @IBAction func openBoxScoreOnWebBrowser(_ sender: Any) {
        /// learn how to open it
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
        print("deinit GameBoxScoreViewController")
    }
    
}

fileprivate extension GameBoxScoreViewController {
    
    func updateUI() {
        guard let game = self.game
            else { return }
        homeImageView?.sd_setImage(with: URL(string:game.homeImageUrl), placeholderImage: UIImage(named: "emptyImage"))
        awayImageView?.sd_setImage(with: URL(string:game.awayImageUrl), placeholderImage: UIImage(named: "emptyImage"))
        if game.played {
            resultLabel?.text = "\(game.homeScore) : \(game.awayScore)"
            detailLabel?.text = "\(game.homeTv)        \(game.awayTv)"
        }
        else {
            resultLabel?.text = "Tip-Off"
            detailLabel?.text = "\(game.time)"
        }
        codeLabel?.text = "#\(game.homeTv)\(game.awayTv)"
        let date = "\(Date().convertDateToString(game.date))|\(game.time)"
        dateLabel?.text = date
    }
    
}

extension GameBoxScoreViewController: UITableViewDelegate {
    
}

extension GameBoxScoreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if game?.localTeamGameDetail != nil && game?.roadTeamGameDetail != nil {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if game?.localTeamGameDetail != nil && game?.roadTeamGameDetail != nil {
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MVPCell") {
            if let tableCell = cell as? BoxScoreMVPTableViewCell {
                if let localTeam = game?.localTeamGameDetail,
                    let roadTeam = game?.roadTeamGameDetail{
                    let boxScoreInfo = boxScoreViewModel.boxScoreInfo(
                        forIndex: indexPath.row, withLocalTeam: localTeam, withRoadTeam: roadTeam)
                    tableCell.typeLabel.text = boxScoreInfo.name
                    tableCell.awayPlayerLabel.text = boxScoreInfo.guestTeamPlayerName
                    tableCell.awayPointsLabel.text = boxScoreInfo.guestTeamPlayerPointText
                    tableCell.homePlayerLabel.text = boxScoreInfo.homeTeamPlayerName
                    tableCell.homePlayerPoints.text = boxScoreInfo.homeTeamPlayerPointText
                    
                }
                
            }
            if indexPath.row == 4 {
                DispatchQueue.main.async {
                    self.tableViewHeightConstrain.constant = self.tableView.contentSize.height
                    
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension GameBoxScoreViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 40)
    }
    
}

extension GameBoxScoreViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if game?.localTeamGameDetail != nil && game?.roadTeamGameDetail != nil {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if game?.localTeamGameDetail != nil && game?.roadTeamGameDetail != nil {
            return game?.getQuartersPlayed() ?? 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuarterCell", for: indexPath)
            as? BoxScoreQuarterCollectionViewCell {
            if let localTeam = game?.localTeamGameDetail,
                let roadTeam = game?.roadTeamGameDetail {
                var qoute = "Q"
                var row = indexPath.row + 1
                var text = ""
                if indexPath.row > 3 {
                    qoute = "QT"
                    row -= 4
                }
                let localScore = localTeam.getQuarter(ofRow: indexPath.row)
                let roadScore = roadTeam.getQuarter(ofRow: indexPath.row)
                if localScore != 0 && roadScore != 0 {
                    text = "\(qoute)\(row)   \(localScore) : \(roadScore)"
                }
                cell.quarterResult.text = text
                
            }
            if indexPath.row % 2 == 0 {
                cell.quarterResult.textAlignment = .right
            }
            else {
                cell.quarterResult.textAlignment = .left
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension GameBoxScoreViewController: BoxScoreViewModelDelegate{
    
    func updateData(withLocalTeam localTeamDetail: GameTeamDetail?, roadTeam roadTeamDetail: GameTeamDetail?){
        game?.localTeamGameDetail = localTeamDetail
        game?.roadTeamGameDetail = roadTeamDetail
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
        self.view.layoutIfNeeded()
        DispatchQueue.main.async {
            self.tableViewHeightConstrain.constant = self.tableView.contentSize.height
        }
        updateUI()
    }
    
}
