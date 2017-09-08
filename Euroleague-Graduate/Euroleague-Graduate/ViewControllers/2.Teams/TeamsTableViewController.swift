//
//  TeamsTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import EuroLeagueKit

class TeamsTableViewController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!

    fileprivate var teams: [[Team]] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    fileprivate let teamViewModel = TeamsTableViewModel(season: Constants.season)
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
        teamViewModel.getData(withData: nil) { teamsList in
            if let clubs = teamsList as? [[Team]] {
                if Thread.isMainThread {
                    self.teams = clubs
                } else {
                    DispatchQueue.main.async {
                        self.teams = clubs
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTeam" {
            if let destination = segue.destination as? TeamDataViewController {
                destination.team = selectedTeam
            }
        }
    }

}

extension TeamsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader")
        if let label = headerCell?.viewWithTag(123) as? UILabel {
            if let char = teams[section][0].name.uppercased().characters.first {
                label.text = String(describing: char)
            }
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
            if let text = team[0].name.uppercased().characters.first {
                sections.append(String(describing: text))
            }
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
                } else {
                    teamsCell.separatorHeightConstraint.constant = 7
                }
            }
            return cell
        }
        return UITableViewCell()
    }

}
