//
//  PlayersTableViewCell.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import SDWebImage
import EuroLeagueKit

class PlayersTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var playerImageView: UIImageView!
    @IBOutlet fileprivate weak var playerNameLabel: UILabel!
    @IBOutlet fileprivate weak var dorsalLabel: UILabel!
    @IBOutlet fileprivate weak var countryNameLabel: UILabel!
    @IBOutlet fileprivate weak var separator: UIView!
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!

    var player: Player? {
        didSet {
            updateUI()
        }
    }

}

fileprivate extension PlayersTableViewCell {

    func updateUI() {
        guard let player = self.player
            else { return }
        playerNameLabel?.text = player.name
        var text = ""
        if player.position.caseInsensitiveCompare("Coach") != .orderedSame {
            text = "#\(player.dorsal) "
        }
        text.append(player.position.capitalizingFirstLetter())
        dorsalLabel?.text = text
        countryNameLabel?.text = player.countryName
        playerImageView.layer.cornerRadius = playerImageView.bounds.width / 2
        playerImageView.layer.masksToBounds = true
        playerImageView.layer.borderWidth = 1.0
        playerImageView.layer.borderColor = UIColor.black.cgColor
        playerImageView?.sd_setImage(with: URL(string:player.imageUrl), placeholderImage: UIImage(named: "emptyPlayer"))
    }

}
