//
//  TurkishLeagueRegularSeosonTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TurkishLeagueRegularSeosonTableViewController: UITableViewController, IndicatorInfoProvider {

    var schedule: [Array<GameData>]?
    let round = "RS"
    
    var turkishViewModel: TurkishLeagueViewModel? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        turkishViewModel = TurkishLeagueViewModel()
        schedule = turkishViewModel?.getDataOfRound(round)
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
     //   performSegue(withIdentifier: "showDetailSegue", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}


