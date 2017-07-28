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
    
    fileprivate var schedule: [Array<GameData>]? {
        didSet {
            tableView?.reloadData()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private let headerCellColor = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1)
        
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
        tableView.backgroundColor = headerCellColor
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = 137
        tableView.separatorColor = headerCellColor
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
    
    // IndicatorProvider method
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "")
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
        view.backgroundColor = headerCellColor
        let label = UILabel()
        label.text = Date().convertDateToString((schedule?[section][0].date)!)
        label.textColor = UIColor.white
        label.font = UIFont(name: "CoText-Regular", size: 12)
        label.frame = CGRect(x: 10, y: 7, width: 100, height: 18)
        view.addSubview(label)
        return view
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

extension TurkishLeagueMasterTableViewController: PagerUpdateChildData {
    
    func updateUIWithData(_ table: [Array<GameData>], lastGameIndex: (section: Int, row: Int)) {
        func getPositionOfGame(index: (section: Int, row: Int)) -> CGFloat{
            var curSection = 0
            var height = 0
            for games in schedule! {
                if curSection < index.section {
                    curSection += 1
                    height += (137 * games.count)
                    height += (7 * games.count)
                    height += 25
                }
                else if curSection == index.section {
                    height += 25
                    var curRow = 0
                    for _ in games {
                        if curRow < index.row {
                            curRow += 1
                            height += 7
                            height += 137
                        }
                        else {
                            height += 137
                            break
                        }
                    }
                    break
                }
            }
            return CGFloat(height)
        }
        schedule = table
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let indexPath = IndexPath(row: lastGameIndex.row, section: lastGameIndex.section)
            if let cell = self.tableView.cellForRow(at: indexPath) {
                print("**** \(cell.frame)")
                self.tableView.scrollRectToVisible(
                    CGRect(x: 0, y:(cell.frame.origin.y), width: self.tableView.bounds.width, height: 137),
                    animated: true)
            }
        }
        
      
     //   tableView.reloadRows(at: [indexPath], with: .none)
//        tableView.scrollRectToVisible(
//            CGRect(x: 0, y: getPositionOfGame(index: lastGameIndex), width: tableView.bounds.width, height: 137),
//            animated: true)
//        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func getRound() -> String {
        return ""
    }
    
}
