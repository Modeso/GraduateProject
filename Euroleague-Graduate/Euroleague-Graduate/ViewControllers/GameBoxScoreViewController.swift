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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableViewHeightConstrain: NSLayoutConstraint!
    
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewHeightConstrain.constant = tableView.contentSize.height
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MVPCell") {
            if let tableCell = cell as? BoxScoreMVPTableViewCell {
                /// Fill data of items
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension GameBoxScoreViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 40)
    }
    
}

extension GameBoxScoreViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewHeightConstrain.constant = collectionView.contentSize.height
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuarterCell", for: indexPath)
            as? BoxScoreQuarterCollectionViewCell {
            cell.quarterResult.text = "Q\(indexPath.row + 1)   -- : --"
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
