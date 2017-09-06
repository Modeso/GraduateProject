//
//  TurkishLeagueMasterTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/27/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EuroLeagueKit

protocol UpdateRoundDataDelegate: class {
    func getDataToShow(ofRound round: String, completion: ([[Game]], (section: Int, row: Int)) -> Void)
    func getUpdatedData(ofRound round: String)
    func isRefreshing() -> Bool
}

class MatchesTableViewController: UITableViewController,
IndicatorInfoProvider {

    fileprivate var schedule: [[Game]]? {
        didSet {
            if isAppear {
                self.tableView?.reloadData()
            }
            print("completion endRefreshing with data")
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    fileprivate var indexPath: IndexPath?

    fileprivate var selectedGame = Game()

    fileprivate var firstLoad = true

    fileprivate var isAppear = false

    weak var delegate: UpdateRoundDataDelegate?

    var round: LeagueRound = LeagueRound()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        tableView.refreshControl?.tintColor = UIColor.white
        tableView.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        delegate?.getDataToShow(ofRound: self.round.name) { (table, lastPlayed) in
            self.schedule = table
            self.indexPath = IndexPath(row: lastPlayed.row, section: lastPlayed.section)
        }
    }

    func refresh() {
        if let refreshing = delegate?.isRefreshing(),
            !refreshing {
            print("completion beginRefreshing \(round.name)")
            tableView.refreshControl?.beginRefreshing()
            delegate?.getUpdatedData(ofRound: round.name)
        } else {
            tableView.refreshControl?.endRefreshing()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAppear = true
        if let count = schedule?.count,
            count > 0 {
            if firstLoad {
                firstLoad = false
                tableView.reloadData()
                if let count = schedule?.count,
                    count < 1 {
                    firstLoad = true
                }
                DispatchQueue.main.async {
                    self.moveToLastPlayed()
                }
            }
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isAppear = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameDetailViewController {
            destination.game = selectedGame
        }
    }

    // IndicatorProvider method
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: round.name)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedule?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule?[section].count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesTableCell", for: indexPath)
        let game = schedule?[indexPath.section][indexPath.row]
        if let leagueCell = cell as? GamesTableViewCell {
            leagueCell.game = game
            if let rowcount = schedule?[indexPath.section].count, indexPath.row == rowcount - 1 {
                leagueCell.separatorHeightConstraint.constant = 0
            } else {
                leagueCell.separatorHeightConstraint.constant = 7
            }
            return leagueCell
        }
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader")
        if let label = headerCell?.viewWithTag(123) as? UILabel {
            label.text = schedule?[section][0].date.convertDateToString()
        }
        return headerCell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let game = schedule?[indexPath.section][indexPath.row] {
            selectedGame = game
            performSegue(withIdentifier: "showDetailSegue", sender: self)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }

}

extension MatchesTableViewController {

    func moveToLastPlayed() {
        guard let index = indexPath
            else { return }
        tableView.scrollToRow(at: index, at: .top, animated: true)
    }

}

extension MatchesTableViewController: PagerUpdateChildData {

    func updateUIWithData(_ table: [[Game]]?, lastGameIndex: (section: Int, row: Int)?) {
        guard let table = table, let lastGameIndex = lastGameIndex else {
            self.tableView?.refreshControl?.endRefreshing()
            print("completion endRefreshing with no data")
            return
        }
        schedule = table
        let indexPath = IndexPath(row: lastGameIndex.row, section: lastGameIndex.section)
        if isAppear {
            if !firstLoad {
                if lastGameIndex.section != self.indexPath?.section, lastGameIndex.row != self.indexPath?.row {
                    self.indexPath = indexPath
                    moveToLastPlayed()
                }
            } else {
                firstLoad = false
                self.indexPath = indexPath
                moveToLastPlayed()
            }
        } else {
            self.indexPath = indexPath
        }
    }

    func getRound() -> String {
        return round.name
    }

}
