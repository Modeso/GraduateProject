//
//  RostersTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/3/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift
import EuroLeagueKit

class RostersTableViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet fileprivate weak var tableView: UITableView!

    fileprivate var rosters: [[Player]] = []
    fileprivate let playersViewModel = RostersTableViewModel(season: Constants.season)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        tableView.reloadData()
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "ROSTER"
    }

    func setUpPlayers(_ players: [Player]) {
        rosters = playersViewModel.makeRostersOf(players)
        self.tableView?.reloadData()
    }

}

extension RostersTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "PlayersTableCell" {
            if rosters[indexPath.section][indexPath.row].imageUrl == "" {
                let code: Any = rosters[indexPath.section][indexPath.row].code
                playersViewModel.getData(withData: [code]) { [weak self] playerArray in
                    if let mArray = playerArray,
                        mArray.count > 0,
                        let mPlayer = mArray[0] as? Player {
                        self?.rosters[indexPath.section][indexPath.row] = mPlayer
                        if let playerCell = tableView.cellForRow(at: indexPath) as? PlayersTableViewCell {
                            playerCell.player = mPlayer
                        }
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader")
        if let label = headerCell?.viewWithTag(123) as? UILabel {
            let char = rosters[section][0].position
            label.text = String(describing: char.capitalizingFirstLetter())
        }
        return headerCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }

}

extension RostersTableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return rosters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosters[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayersTableCell") {
            if let playerCell = cell as? PlayersTableViewCell {
                playerCell.player = rosters[indexPath.section][indexPath.row]
                if indexPath.row == (rosters[indexPath.section].count - 1) {
                    playerCell.separatorHeightConstraint.constant = 0
                } else {
                    playerCell.separatorHeightConstraint.constant = 7
                }
            }
            return cell
        }
        return UITableViewCell()
    }

}
