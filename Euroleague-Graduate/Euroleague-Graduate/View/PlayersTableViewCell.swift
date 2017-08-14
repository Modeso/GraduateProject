//
//  PlayersTableViewCell.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import SDWebImage

class PlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var dorsalLabel: UILabel!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!
    
    var player: Player? {
        didSet{
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
        text.append(player.position)
        dorsalLabel?.text = text
        countryNameLabel?.text = player.countryName
        playerImageView.layer.cornerRadius = playerImageView.bounds.width / 2
        playerImageView.layer.masksToBounds = true
        playerImageView.layer.borderWidth = 1.0
        playerImageView.layer.borderColor = UIColor.black.cgColor
        playerImageView?.sd_setImage(with: URL(string:player.imageUrl), placeholderImage: UIImage(named: "emptyImage"))
    }
    
}
