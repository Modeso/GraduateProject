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
    
    fileprivate let boxScoreViewModel = BoxScoreViewModel()
    
    fileprivate let gameDetailBoxScoreService = GameDetailBoxScoreService()
    
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
        gameDetailBoxScoreService.delegate = self
        if game?.localTeamGameDetail == nil || game?.roadTeamGameDetail == nil {
            if let code = game?.gameNumber {
                gameDetailBoxScoreService.getScoreBoxResults(ofGameWithCode: String(code))
            }
        }
        
        // CollectionView Settings
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        updateUI()
        collectionView.autoresizingMask = [UIViewAutoresizing.flexibleHeight]
        
        // TableView Settings
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("didlayoutsubviewsß")
        tableViewHeightConstrain.constant = tableView.contentSize.height

    }
    
    @IBAction func openBoxScoreOnWebBrowser(_ sender: Any) {
        /// learn how to open it
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section number is \(indexPath.section)")
        print("row number is \(indexPath.row)\n")
    }
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
                tableViewHeightConstrain.constant = tableView.contentSize.height

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
        collectionViewHeightConstrain.constant = collectionView.contentSize.height
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuarterCell", for: indexPath)
            as? BoxScoreQuarterCollectionViewCell {
            if let localTeam = game?.localTeamGameDetail,
                let roadTeam = game?.roadTeamGameDetail {
                cell.quarterResult.text =
                    "Q\(indexPath.row + 1)   \(localTeam.getQuarter(ofRow: indexPath.row)) : \(roadTeam.getQuarter(ofRow: indexPath.row))"
            }
            else {
                cell.quarterResult.text = "Q\(indexPath.row + 1)   -- : --"
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

extension GameBoxScoreViewController: GameDetailBoxScoreDataServiceDelegate {
    
    func updateData(localTeamDetail localTeam: GameTeamDetail?, roadTeamDetail roadTeam: GameTeamDetail?) {
        if let game = self.game {
            RealmDBManager.sharedInstance.updateGameTeamsDetailFor(game, localTeam: localTeam, roadTeam: roadTeam)
        }
        collectionView.reloadData()
        
        self.tableView.reloadData()
        DispatchQueue.main.async {
            self.tableViewHeightConstrain.constant = self.tableView.contentSize.height
        }
//        dispatch_async(dispatch_get_main_queue()) {
//            self.tableHeightConstraint.constant = self.tableView.contentSize.height
//            UIView.animateWithDuration(0.4) {
//                self.view.layoutIfNeeded()
//            }
//        }

        
    }
    
}
