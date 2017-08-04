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
        dorsalLabel?.text = "#\(player.dorsal) \(player.position)"
        countryNameLabel?.text = player.countryName
        playerImageView?.sd_setImage(with: URL(string:player.imageUrl), placeholderImage: UIImage(named: "emptyImage"))
    }
    
}
