//
//  TurkishLeagueTeamsTableViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class TurkishLeagueTeamsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var teams: [Array<Team>] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    private let teamViewModel = TurkishLeagueTeamsViewModel()
    
    fileprivate var selectedTeam: Team?
    
    fileprivate let headerCellColor = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor(patternImage: UIImage(named: "TurkishLeagueBackGround")!)
        
        navigationController?.navigationBar.barTintColor = Colors.TurkishLeagueBarColor
        navigationController?.navigationBar.isTranslucent = false
        let navImage = UIImage(named: "navbar-turkishairlines")
        let navImageView = UIImageView(image: navImage)
        navImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = navImageView
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        teamViewModel.teamsDelegate = self
        teamViewModel.getTeamsData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTeam" {
            if let destination = segue.destination as? TurkishLeagueTeamDataViewController {
                destination.team = selectedTeam!
            }
        }
    }
    

}

extension TurkishLeagueTeamsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader")
        if let label = headerCell?.viewWithTag(123) as? UILabel {
            let char = teams[section][0].name.characters.first!
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
    
}

extension TurkishLeagueTeamsTableViewController: UITableViewDataSource {
    
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
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension TurkishLeagueTeamsTableViewController: TeamsDataViewModelDelegate {
    
    func updateTeamsData(_ table: [Array<Team>]) {
        teams = table
    }
    
}
