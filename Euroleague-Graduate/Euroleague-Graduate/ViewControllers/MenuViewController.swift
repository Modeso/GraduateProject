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
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: view.frame.width / 4, bottom: 0, right: view.frame.width / 4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cell = tableView.cellForRow(at: IndexPath(row: selectedRow, section: 0)) {
            if let tableCell = cell as? MenuTableViewCell {
                tableCell.selectedBarView.backgroundColor = UIColor.white
                tableCell.selectedBarView.alpha = 0.5
            }
        }
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
                }
            }
            selectedRow = indexPath.row
            if let storyboard = self.storyboard {
                self.sideMenuViewController!.setContentViewController(storyboard.instantiateViewController(withIdentifier: identifier), animated: true)
                tableView.deselectRow(at: indexPath, animated: false)
                self.sideMenuViewController!.hideMenuViewController()
            }
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
                tableCell.backgroundColor = UIColor.getLeagueBarColor()
                if indexPath.row == selectedRow {
                    tableCell.selectedBarView.backgroundColor = UIColor.white
                    tableCell.selectedBarView.alpha = 0.5
                }
                else {
                    tableCell.selectedBarView.backgroundColor = UIColor.getLeagueBarColor()
                    tableCell.selectedBarView.alpha = 1.0
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
        selectedLeagueNumber = indexPath.row
        print(selectedLeagueNumber)
        switch selectedLeagueNumber {
        case 0:
            LeaguesCommenObjects.season = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague
            break
        case 1:
            LeaguesCommenObjects.season = LeaguesCommenObjects.Season.EuroCup
            break
        default:
            break
        }
        tableView.backgroundColor = LeaguesCommenObjects.season.getColor()
        topView.backgroundColor = LeaguesCommenObjects.season.getColor()
        collectionView.reloadData()
        tableView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let identifier = menu[selectedRow]?.identifier,
            let storyboard = self.storyboard {
            self.sideMenuViewController!.setContentViewController(storyboard.instantiateViewController(withIdentifier: identifier), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
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
                    cell.leagueImageView.image = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getColoredImage()
                }
                else{
                    cell.leagueImageView.image = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getNonColoredImage()
                }
                
            case 1:
                if indexPath.row == selectedLeagueNumber {
                    cell.leagueImageView.image = LeaguesCommenObjects.Season.EuroCup.getColoredImage()
                }
                else{
                    cell.leagueImageView.image = LeaguesCommenObjects.Season.EuroCup.getNonColoredImage()
                }
                
            default :
                cell.leagueImageView.image = LeaguesCommenObjects.Season.TurkishAirLinesEuroLeague.getColoredImage()
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
}

