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
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var selectedLeagueNumber = 0
    
    fileprivate var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.getLeagueBarColor()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
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
                            tableCell.selectedBarView.backgroundColor = UIColor.getLeagueBarColor()
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

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeagueImageCell", for: indexPath) as? LeagueChooserCollectionViewCell {
            switch indexPath.row{
            case 0:
                cell.leagueImageView.image = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getImage()
            case 1:
                cell.leagueImageView.image = LeaguesCommenObjects.Season.EuroCup.getImage()
            default :
                break
            }
            if let oldCell = collectionView.cellForItem(at: IndexPath(row: selectedLeagueNumber, section: 1)) {
                if let leagueCell = oldCell as? LeagueChooserCollectionViewCell {
                    switch indexPath.row{
                    case 0:
                        leagueCell.leagueImageView.image = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getNavImage()
                    case 1:
                        leagueCell.leagueImageView.image = LeaguesCommenObjects.Season.EuroCup.getNavImage()
                    default :
                        break
                    }
                }

            }
            selectedLeagueNumber = indexPath.row
            collectionView.reloadData()
        }
    }
    
}

extension MenuViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeagueImageCell", for: indexPath)
            as? LeagueChooserCollectionViewCell {
            switch indexPath.row{
            case 0:
                if indexPath.row == selectedLeagueNumber {
                    cell.leagueImageView.image = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getImage()
                }
                else{
                    cell.leagueImageView.image = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getNavImage()
                }
                
            case 1:
                if indexPath.row == selectedLeagueNumber {
                    cell.leagueImageView.image = LeaguesCommenObjects.Season.EuroCup.getImage()
                }
                else{
                    cell.leagueImageView.image = LeaguesCommenObjects.Season.EuroCup.getNavImage()
                }
                
            default :
                cell.leagueImageView.image = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getImage()
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
}

