//
//  TeamStatisticsMenuTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/23/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import EuroLeagueKit

protocol MenuSwapped: class {
    func changeMenuSize(withItemsCount items: Int)
    func changeMenuSize(toHeight height: CGFloat)
    func updateTableData(withRound round: String)
}

class TeamStatisticsMenuTableViewController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var menuButton: UIButton!

    fileprivate var isChoosing = false
    fileprivate var menu: [Int: LeagueRound] = [ : ]

    weak var delegate: MenuSwapped?

    var cellRowHeight: CGFloat = 35.0

    override func viewDidLoad() {
        super.viewDidLoad()
        menu = Constants.season.getTeamStatisticsMenuOptions()
        tableView.reloadData()
        delegate?.changeMenuSize(withItemsCount: 1)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    func getCurrentMenuRound() -> String {
        return menu[1]?.name ?? ""
    }

    @IBAction func menuButtonIsPressed(_ sender: UIButton) {
        if isChoosing {
            isChoosing = false
            menuButton.alpha = 1.0
            delegate?.changeMenuSize(withItemsCount: 1)
        } else {
            isChoosing = true
            menuButton.alpha = 0.5
            delegate?.changeMenuSize(withItemsCount: menu.count)
            tableView.reloadData()
        }
    }

}

extension TeamStatisticsMenuTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isChoosing {
            isChoosing = false
            menuButton.alpha = 1.0
            if indexPath.row != 0 {
                tableView.beginUpdates()
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
                updateTheMenuOrder(toStartWith: indexPath.row + 1)
                tableView.endUpdates()
                if let round = menu[1]?.name {
                    delegate?.updateTableData(withRound: round)
                }
            }
            delegate?.changeMenuSize(withItemsCount: 1)
        } else {
            isChoosing = true
            menuButton.alpha = 0.5
            delegate?.changeMenuSize(withItemsCount: menu.count)
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellRowHeight
    }

}

extension TeamStatisticsMenuTableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStatisticsMenuCell") {
            if let tableCell = cell as? TeamStatisticsMenuTableViewCell {
                if let text = menu[indexPath.row + 1]?.completeName {
                    tableCell.titleLabel.text = "Average Stattistics - \(text)"
                }
            }
            return cell
        }
        return UITableViewCell()
    }

}

fileprivate extension TeamStatisticsMenuTableViewController {

    func updateTheMenuOrder(toStartWith index: Int) {
        swapMenu(first: index, second: 1)
        resortMenu()
    }

    func resortMenu () {
        var swapped = true
        repeat {
            swapped = false
            for i in 2...menu.count - 1 {
                let j = i + 1
                if let firstPriority = menu[j-1]?.priority,
                    let secondPriority = menu[j]?.priority,
                    firstPriority < secondPriority {
                    swapMenu(first: j-1, second: j)
                    swapped = true
                }
            }
        } while swapped
    }

    func swapMenu(first: Int, second: Int) {
        let temp = menu[first]
        menu[first] = menu[second]
        menu[second] = temp
    }
}
