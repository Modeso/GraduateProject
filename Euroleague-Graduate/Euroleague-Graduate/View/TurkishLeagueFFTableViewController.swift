//
//  TurkishLeagueF4TableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TurkishLeagueFFTableViewController: UITableViewController, IndicatorInfoProvider {

    private var schedule: [Array<GameData>]?
    private let round = "FF"
    
    private var turkishViewModel: TurkishLeagueViewModel? = nil
    
    init(style: UITableViewStyle, viewModel: TurkishLeagueViewModel) {
        turkishViewModel = viewModel
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     turkishViewModel = TurkishLeagueViewModel()
        schedule = turkishViewModel?.getDataOfRound(round)
        tableView.register(UINib(nibName: "TurkishLeagueTableCell", bundle: Bundle.main), forCellReuseIdentifier: "TurkishLeagueCell")
        //        tableView.register(TurkishLeagueTableViewCell.self, forCellReuseIdentifier: "TurkishLeagueCell")
        tableView.backgroundColor = UIColor.darkGray
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "F4")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedule?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return schedule?[section].count ?? 1
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
        return convertDateToString((schedule?[section][0].date)!)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GameDetailScreen") as? TurkishLeagueGameDetailViewController {
            if let navigator = navigationController {
                //                navigator.pushViewController(viewController, animated: true)
                navigator.showDetailViewController(viewController, sender: self)
            }
        }
    }

}
