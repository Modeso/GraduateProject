//
//  TurkishLeagueMasterTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/27/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MasterTableViewController: UITableViewController,
IndicatorInfoProvider {
    
    fileprivate var schedule: [Array<Game>]? {
        didSet {
            if isAppear {
                self.tableView?.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    fileprivate var indexPath: IndexPath?
    
    fileprivate var selectedGame = Game()
    
    fileprivate var firstLoad = true
    
    fileprivate var isAppear = false
    
    weak var pagerDelegate: PagerUpdateDelegate?
    
    var round: (round: String, name: String, completeName: String) = ("", "", "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        
        tableView.refreshControl?.tintColor = UIColor.white
        tableView.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    }
    
    func refresh() {
        if !pagerDelegate!.isRefreshing() {
            tableView.refreshControl?.beginRefreshing()
            pagerDelegate?.getUpdatedData()
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
                    count < 1{
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
            }
            else {
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
            label.text = Date().convertDateToString((schedule?[section][0].date)!)
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
    
    deinit {
        print("deinit MasterTableViewController")
    }
    
}

extension MasterTableViewController {
    
    func moveToLastPlayed() {
        guard let index = indexPath
            else { return }
        tableView.scrollToRow(at: index, at: .top, animated: true)
    }
    
}

extension MasterTableViewController: PagerUpdateChildData {
    
    func updateUIWithData(_ table: [Array<Game>], lastGameIndex: (section: Int, row: Int)) {
        schedule = table
        let indexPath = IndexPath(row: lastGameIndex.row, section: lastGameIndex.section)
        if isAppear {
            if !firstLoad {
                if lastGameIndex.section != self.indexPath?.section , lastGameIndex.row != self.indexPath?.row {
                    self.indexPath = indexPath
                    moveToLastPlayed()
                }
            }
            else {
                self.indexPath = indexPath
                moveToLastPlayed()
            }
        }
        else {
            self.indexPath = indexPath
        }
    }
    
    func getRound() -> String {
        return round.round
    }
    
}
