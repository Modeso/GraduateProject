//
//  GameBoxScoreViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/17/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EuroLeagueKit

class GameBoxScoreViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet fileprivate weak var homeImageView: UIImageView!
    @IBOutlet fileprivate weak var awayImageView: UIImageView!
    @IBOutlet fileprivate weak var resultLabel: UILabel!
    @IBOutlet fileprivate weak var detailLabel: UILabel!
    @IBOutlet fileprivate weak var separator: UIView!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var codeLabel: UILabel!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var collectionViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var tableViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet fileprivate weak var browserButton: UIButton!

    fileprivate let boxScoreViewModel = BoxScoreViewModel(season: Constants.season)

    var game: Game? {
        didSet {
            updateUI()
        }
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "BOXSCORE"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        browserButton.backgroundColor = Constants.season.getColor()
        collectionViewHeightConstrain.constant = 0
        tableViewHeightConstrain.constant = 0
        collectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old.union(NSKeyValueObservingOptions.new), context: nil)

        if let code = game?.gameCode {
            let data: Any = code
            boxScoreViewModel.getData(withData: [data]) { [weak self] detailArray in
                if let detailData = detailArray as? [GameTeamDetail] {
                    self?.game?.localTeamGameDetail = detailData[0]
                    self?.game?.roadTeamGameDetail = detailData[1]
                    self?.updateUI()
                }
            }
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

    // Observer on collectionView contentSize
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            self.collectionViewHeightConstrain.constant = self.collectionView.contentSize.height
        }
    }

    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
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
        } else {
            resultLabel?.text = "Tip-Off"
            detailLabel?.text = "\(game.time)"
        }
        codeLabel?.text = "#\(game.homeTv)\(game.awayTv)"
        let date = "\(game.date.convertDateToString())|\(game.time)"
        dateLabel?.text = date

        self.collectionView?.reloadData()
        self.tableView?.reloadData()
        self.view.layoutIfNeeded()
        DispatchQueue.main.async {
            self.tableViewHeightConstrain?.constant = self.tableView?.contentSize.height ?? 0
        }
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
                    let roadTeam = game?.roadTeamGameDetail {
                    let boxScoreInfo = boxScoreViewModel.boxScoreInfo(
                        forIndex: indexPath.row, withLocalTeam: localTeam, withRoadTeam: roadTeam)
                    tableCell.boxScore = boxScoreInfo
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
            } else {
                cell.quarterResult.textAlignment = .left
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
