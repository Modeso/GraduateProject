//
//  MenuViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    fileprivate let menu: Dictionary<Int, (text: String, identifier: String)> = [
        0 : ("Games","GamesContentNavigationController"),
        1 : ("Teams","TeamsContentNavigationController")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.getTurkishLeagueBarColor()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cell = tableView.cellForRow(at: IndexPath(row: selectedRow, section: 0)) {
            if let tableCell = cell as? MenuTableViewCell {
                tableCell.selectedBarView.backgroundColor = UIColor.white
                tableCell.selectedBarView.alpha = 0.5
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let identifier = menu[indexPath.row]?.identifier {
            if let cell = tableView.cellForRow(at: indexPath) {
                if let tableCell = cell as? MenuTableViewCell {
                    tableCell.selectedBarView.backgroundColor = UIColor.white
                    if let cell = tableView.cellForRow(at: IndexPath(row: selectedRow, section: 0)) {
                        if let tableCell = cell as? MenuTableViewCell {
                            tableCell.selectedBarView.backgroundColor = UIColor.getTurkishLeagueBarColor()
                            tableCell.selectedBarView.alpha = 1
                        }
                    }
                    selectedRow = indexPath.row
                }
            }
            self.sideMenuViewController!.setContentViewController(self.storyboard!.instantiateViewController(withIdentifier: identifier), animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
            self.sideMenuViewController!.hideMenuViewController()
        }
    }
    
}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") {
            if let tableCell = cell as? MenuTableViewCell {
                tableCell.nameLabel.text = menu[indexPath.row]?.text
                if indexPath.row == selectedRow {
                    tableCell.selectedBarView.backgroundColor = UIColor.white
                    tableCell.selectedBarView.alpha = 0.5
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

