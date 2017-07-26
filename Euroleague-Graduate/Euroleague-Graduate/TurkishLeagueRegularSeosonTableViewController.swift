//
//  TurkishLeagueRegularSeosonTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TurkishLeagueRegularSeosonTableViewController: UITableViewController,
IndicatorInfoProvider, PagerUpdateChildData {

    private var schedule: [Array<GameData>]? {
        didSet {
            tableView?.reloadData()
        }
    }
    private let round = "RS"
    
    private var pagerDelegate: PagerUpdateDelegate?
    
    func setDelegate(_ delegate: PagerUpdateDelegate) {
        pagerDelegate = delegate
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TurkishLeagueTableCell", bundle: Bundle.main), forCellReuseIdentifier: "TurkishLeagueCell")
//        tableView.register(TurkishLeagueTableViewCell.self, forCellReuseIdentifier: "TurkishLeagueCell")
        tableView.backgroundColor = UIColor.lightGray
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: round)
    }
    
    func updateUIWithData(_ table: [Array<GameData>]) {
        schedule = table
    }
    
    func getRound() -> String {
        return round
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TurkishLeagueCell", for: indexPath)
        let game = schedule?[indexPath.section][indexPath.row]
        if let leagueCell = cell as? TurkishLeagueTableViewCell {
            leagueCell.game = game
        }
        return cell
    }
    
    func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let headerView = view as? UITableViewHeaderFooterView {
//            headerView.textLabel?.textColor = UIColor.red
//        }
        if schedule == nil {
            return ""
        }
        return convertDateToString((schedule?[section][0].date)!)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GameDetailScreen") as? TurkishLeagueGameDetailViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
//                navigator.showDetailViewController(viewController, sender: self)
            }
        }
    }

}


