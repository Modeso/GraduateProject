//
//  TeamsTableViewCell.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import SDWebImage
import EuroLeagueKit

class TeamsTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var teamImageView: UIImageView!
    @IBOutlet fileprivate weak var teamNameLabel: UILabel!
    @IBOutlet fileprivate weak var tvCodeLabel: UILabel!
    @IBOutlet fileprivate weak var countryNameLabel: UILabel!
    @IBOutlet fileprivate weak var separator: UIView!
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!

    var team: Team? {
        didSet {
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
