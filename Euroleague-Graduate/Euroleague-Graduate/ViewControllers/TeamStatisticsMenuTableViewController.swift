//
//  TeamStatisticsMenuTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/23/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class TeamStatisticsMenuTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var isChoosing = false
    
    var delegate: MenuSwapped?
    
    fileprivate var menu: Dictionary<Int,(text: String, priority: Int, round: String)> = [
        1 : ("All phases", 100, "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        menu = LeaguesCommenObjects.season.getTeamStatisticsMenuOptions()
        delegate?.changeMenuSize(toHeight: tableView.rowHeight)
        tableView.reloadData()
    }
    
    func getCurrentMenuRound() -> String {
        return menu[1]?.round ?? ""
    }
}

extension TeamStatisticsMenuTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isChoosing {
            isChoosing = false
            if indexPath.row != 0 {
                tableView.beginUpdates()
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
                updateTheMenuOrder(toStartWith: indexPath.row)
                tableView.endUpdates()
                if let round = menu[1]?.round{
                    delegate?.updateTableData(withRound: round)
                }
            }
            delegate?.changeMenuSize(toHeight: tableView.rowHeight)
        }
        else{
            isChoosing = true
            delegate?.changeMenuSize(toHeight: tableView.rowHeight * CGFloat(menu.count))
            tableView.reloadData()
        }
        
    }
}

extension TeamStatisticsMenuTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isChoosing ? menu.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamStatisticsMenuCell") {
            if let tableCell = cell as? TeamStatisticsMenuTableViewCell {
                if indexPath.row == 0 {
                    tableCell.menuButton.isHidden = false
                    if isChoosing {
                        tableCell.menuButton.alpha = 0.5
                    }
                    else {
                        tableCell.menuButton.alpha = 1.0
                    }
                }
                else {
                    tableCell.menuButton.isHidden = true
                }
                if let text = menu[indexPath.row]?.text {
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
        swapMenu(index, 1)
    }
    
    func swapMenu(_ i: Int, _ j: Int){
        let temp = menu[i]
        menu[i] = menu[j]
        menu[j] = temp
    }
}

