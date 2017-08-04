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

class RostersTableViewController: UIViewController , IndicatorInfoProvider{
    
    var coach = Player()
    
//    var players = List<Player>() {
//        didSet {
//            if coach.name != "" {
//                makeRosters()
//                tableView?.reloadData()
//            }
//            
//        }
//    }
    
    var players: Dictionary<String,Player> = [:]
    
    fileprivate var rosters: [Array<Player>] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clear
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "ROSTER"
    }
    
    func makeRostersOf(_ players: [Player]) {
        var rostersTable: Dictionary<String,[Player]> = [:]
        for player in players {
            ///call data
            rostersTable[player.position]?.append(player)
            
        }
        var positions:[String] = Array(rostersTable.keys)
        positions.sort()
        rosters.append([coach])
        for position in positions {
            rosters.append(rostersTable[position]!)
        }
    }
    
}

extension RostersTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}

extension RostersTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayersTableCell") {
            if let playerCell = cell as? PlayersTableViewCell {
                playerCell.player = rosters[indexPath.section][indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

fileprivate extension RostersTableViewController {
    
    
    
}
