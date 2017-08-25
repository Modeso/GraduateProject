//
//  TurkishLeagueTeamsTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class TeamsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var teams: [Array<Team>] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    private let teamViewModel = TeamsViewModel(season: LeaguesCommenObjects.season)
    
    fileprivate var selectedTeam: Team?
    
    fileprivate let headerCellColor = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor.white
        tableView.sectionIndexBackgroundColor = UIColor.getLeagueBackGroundColor()
        if let image = UIImage(named: "LeagueBackGround") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        teamViewModel.delegate = self
        teamViewModel.getTeamsData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTeam" {
            if let destination = segue.destination as? TeamDataViewController {
                destination.team = selectedTeam!
            }
        }
    }
    
    deinit {
        print("deinit TeamsTableViewController")
    }

}

extension TeamsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader")
        if let label = headerCell?.viewWithTag(123) as? UILabel {
            let char = teams[section][0].name.uppercased().characters.first!
            label.text = String(describing: char)
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeam = teams[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "ShowTeam", sender: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var sections: [String] = []
        for team in teams {
            sections.append(String(describing: team[0].name.uppercased().characters.first!))
        }
        return sections
    }
    
}

extension TeamsTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamsTableCell") {
            if let teamsCell = cell as? TeamsTableViewCell {
                teamsCell.team = teams[indexPath.section][indexPath.row]
                if indexPath.row == (teams[indexPath.section].count - 1) {
                    teamsCell.separatorHeightConstraint.constant = 0
                }
                else {
                    teamsCell.separatorHeightConstraint.constant = 7
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension TeamsTableViewController: TeamsDataViewModelDelegate {
    
    func updateTeamsData(_ table: [Array<Team>]) {
        teams = table
    }
    
}
