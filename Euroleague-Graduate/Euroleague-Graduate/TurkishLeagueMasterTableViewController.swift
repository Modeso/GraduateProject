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
IndicatorInfoProvider, PagerUpdateChildData {
    
    private var schedule: [Array<GameData>]? {
        didSet {
            tableView?.reloadData()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private let color = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1)
        
    var pagerDelegate: PagerUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "TurkishLeagueTableCell", bundle: Bundle.main),
            forCellReuseIdentifier: "TurkishLeagueCell")
        tableView.register(
            UINib(nibName: "TurkishLeagueTableHeaderCell",bundle: Bundle.main),
            forHeaderFooterViewReuseIdentifier: "TurkishLeagueHeaderCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = color
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = 150
        tableView.separatorColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
   
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.isEnabled = true
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Loading")
        tableView.refreshControl?.backgroundColor = UIColor.white
        tableView.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    }
    
    func refresh() {
        if !pagerDelegate!.isResreshing() {
            tableView.refreshControl?.beginRefreshing()
            pagerDelegate?.getUpdatedData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "")
    }
    
    func updateUIWithData(_ table: [Array<GameData>]) {
        schedule = table
    }
    
    func getRound() -> String {
        return ""
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
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 60.0/255, green: 60.0/255, blue: 60.0/255, alpha: 1)
        let label = UILabel()
        label.text = Date().convertDateToString((schedule?[section][0].date)!)
        label.textColor = UIColor.white
        label.frame = CGRect(x: 10, y: 5, width: 100, height: 22)
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GameDetailScreen") as? TurkishLeagueGameDetailViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

}
