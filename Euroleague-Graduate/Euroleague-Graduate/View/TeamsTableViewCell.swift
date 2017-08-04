//
//  TurkishLeagusTeamsTableViewCell.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import SDWebImage

class TeamsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var tvCodeLabel: UILabel!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet weak var separator: UIView!
    
    var team: Team? {
        didSet{
            updateUI()
        }
    }

}

fileprivate extension TeamsTableViewCell {
    
    func updateUI() {
        guard let team = self.team
            else { return }
        teamNameLabel?.text = team.name
        tvCodeLabel?.text = team.tvCode
        countryNameLabel?.text = team.countryName
        teamImageView?.sd_setImage(with: URL(string:team.logoUrl), placeholderImage: UIImage(named: "emptyImage"))
    }
    
}
