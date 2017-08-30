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

class RostersTableViewController: UIViewController, IndicatorInfoProvider {

    var coach = Player()

    fileprivate var rosters: [Array<Player>] = []

    fileprivate let playersViewModel = PlayerViewModel(season: LeaguesCommenObjects.season)

    @IBOutlet weak var tableView: UITableView!

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

    func makeRostersOf(_ players: [Player]) {
        var rostersTable: Dictionary<String, [Player]> = [:]
        var newPlayers = players
        newPlayers.remove(at: 0)
        var positions: [String] = []
        for player in newPlayers {

            if !positions.contains(player.position) {
                positions.append(player.position)
                rostersTable[player.position] = []
            }
            rostersTable[player.position]?.append(player)
        }
        positions.sort()
        self.rosters.append([coach])
        for position in positions {
            if var samePositionPlayers = rostersTable[position] {
                samePositionPlayers = samePositionPlayers.sorted { $0.dorsal < $1.dorsal }
                self.rosters.append(samePositionPlayers)
            }

        }
        self.tableView?.reloadData()
    }

    deinit {
        print("deinit RostersTableViewController")
    }
}

extension RostersTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "PlayersTableCell" {
            if rosters[indexPath.section][indexPath.row].imageUrl == "" {
                playersViewModel.updatePlayer(withCode: rosters[indexPath.section][indexPath.row].code) { [weak self] player in
                    self?.rosters[indexPath.section][indexPath.row] = player
                    self?.tableView.reloadData()
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
