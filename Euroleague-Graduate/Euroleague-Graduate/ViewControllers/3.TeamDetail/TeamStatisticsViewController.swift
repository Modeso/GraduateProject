//
//  TeamStatisticsViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/14/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TeamStatisticsViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var menuContainerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!

    fileprivate var menuViewController: TeamStatisticsMenuTableViewController?

    fileprivate let teamStatisticsModel = TeamStatisticTableRowsModel()

    fileprivate var startHeight: CGFloat = 35

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "STATISTICS"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startHeight = menuContainerHeightConstraint.constant
        view.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        //most likely will go with default ask about it
        teamStatisticsModel.getDataAccordingToMenu(round: menuViewController?.getCurrentMenuRound() ?? "")
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedMenu",
            let menuViewController = segue.destination as? TeamStatisticsMenuTableViewController {
            menuViewController.delegate = self
            menuViewController.cellRowHeight = menuContainerHeightConstraint.constant
        }
    }

}

extension TeamStatisticsViewController: MenuSwapped {

    func changeMenuSize(toHeight height: CGFloat) {
        menuContainerHeightConstraint.constant = height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func changeMenuSize(withItemsCount items: Int) {
        menuContainerHeightConstraint.constant = startHeight * CGFloat(items)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func updateTableData(withRound round: String) {
        teamStatisticsModel.getDataAccordingToMenu(round: round)
        tableView.reloadData()
    }

}

extension TeamStatisticsViewController: UITableViewDelegate {

}

extension TeamStatisticsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamStatisticsModel.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "teamStatisticsCell") {
            if let tableCell = cell as? TeamStatisticsTableViewCell {
                let detailText = teamStatisticsModel.rows[indexPath.row]
                tableCell.detailNameLabel.text = detailText
                if let result = teamStatisticsModel.results[detailText] {
                    if !detailText.contains("%") {
                        tableCell.resultLabel.text = String(Int(result))
                    } else {
                        tableCell.resultLabel.text = String(result)
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }

}
