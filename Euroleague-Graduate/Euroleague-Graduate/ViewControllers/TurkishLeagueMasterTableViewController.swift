//
//  TurkishLeagueMasterTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/27/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TurkishLeagueMasterTableViewController: UITableViewController,
IndicatorInfoProvider {
    
    fileprivate var schedule: [Array<Game>]? {
        didSet {
            tableView?.reloadData()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    fileprivate var indexPath: IndexPath?
    
    fileprivate var firstLoad = true
    
    var pagerDelegate: PagerUpdateDelegate?
    
    var round: String = ""
    
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
        if firstLoad {
            tableView.reloadData()
            firstLoad = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                self?.moveToLastPlayed()
            })
        }
    }
    
    // IndicatorProvider method
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: round == "FF" ? "F4" : round)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedule?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return schedule?[section].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesTableCell", for: indexPath)
        let game = schedule?[indexPath.section][indexPath.row]
        if let leagueCell = cell as? GamesTableViewCell {
            leagueCell.game = game
            if let rowcount = schedule?[indexPath.section].count, indexPath.row == rowcount - 1 {
                leagueCell.separator.backgroundColor = UIColor.white
            }
            else {
                leagueCell.separator.backgroundColor = Colors.TurkishLeagueBackGroundColor
            }
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
        if let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GameDetailScreen") as? TurkishLeagueGameDetailViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
}

extension TurkishLeagueMasterTableViewController {
    
    func moveToLastPlayed() {
        guard let index = indexPath
            else { return }
        tableView.scrollToRow(at: index, at: .top, animated: true)
    }
    
}

extension TurkishLeagueMasterTableViewController: PagerUpdateChildData {
    
    func updateUIWithData(_ table: [Array<Game>], lastGameIndex: (section: Int, row: Int)) {
        schedule = table
        let indexPath = IndexPath(row: lastGameIndex.row, section: lastGameIndex.section)
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
    
    func getRound() -> String {
        return round
    }
    
}
