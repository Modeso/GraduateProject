//
//  TeamStatisticsMenuTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/23/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

protocol MenuSwapped: class {
    
    func changeMenuSize(withItemsCount items: Int)
    
    func changeMenuSize(toHeight height: CGFloat)
    
    func updateTableData(withRound round: String)
    
}

class TeamStatisticsMenuTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var menuButton: UIButton!
    
    fileprivate var isChoosing = false
    
    weak var delegate: MenuSwapped?
    
    var cellRowHeight:CGFloat = 35.0
    
    fileprivate var menu: Dictionary<Int,(text: String, priority: Int, round: String)> = [
        1 : ("All phases", 100, "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = LeaguesCommenObjects.season.getTeamStatisticsMenuOptions()
        tableView.reloadData()
        delegate?.changeMenuSize(withItemsCount: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()

        
    }
    func getCurrentMenuRound() -> String {
        return menu[1]?.round ?? ""
    }
    
    @IBAction func menuButtonIsPressed(_ sender: UIButton) {
        if isChoosing {
            isChoosing = false
            menuButton.alpha = 1.0
            delegate?.changeMenuSize(withItemsCount: 1)
        }
        else{
            isChoosing = true
            menuButton.alpha = 0.5
            delegate?.changeMenuSize(withItemsCount: menu.count)
            tableView.reloadData()
        }
    }
    
    deinit {
        print("deinit TeamStatisticsMenuTableViewController")
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
                if let round = menu[1]?.round{
                    delegate?.updateTableData(withRound: round)
                }
            }
            delegate?.changeMenuSize(withItemsCount: 1)
        }
        else{
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
                if let text = menu[indexPath.row + 1]?.text {
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
        resortMenu()
    }
    
    func resortMenu () {
        var swapped = true
        repeat{
            swapped = false
            for i in 2...menu.count - 1 {
                let j = i + 1
                if let firstPriority = menu[j-1]?.priority,
                    let secondPriority = menu[j]?.priority,
                    firstPriority < secondPriority {
                    swapMenu(j-1, j)
                    swapped = true
                }
            }
        } while swapped
    }
    
    func swapMenu(_ i: Int, _ j: Int){
        let temp = menu[i]
        menu[i] = menu[j]
        menu[j] = temp
    }
}

