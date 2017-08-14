//
//  TurkishLeagueTableViewCell.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import SDWebImage

class GamesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var homeImageView: UIImageView!
    
    @IBOutlet weak var awayImageView: UIImageView!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!
    
    var game: Game? {
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func updateUI() {
        guard let game = self.game
            else { return }
        homeImageView?.sd_setImage(with: URL(string:game.homeImageUrl), placeholderImage: UIImage(named: "emptyImage"))
        awayImageView?.sd_setImage(with: URL(string:game.awayImageUrl), placeholderImage: UIImage(named: "emptyImage"))
        if game.played {
            resultsLabel?.text = "\(game.homeScore) : \(game.awayScore)"
            detailLabel?.text = "\(game.homeTv)        \(game.awayTv)"
        }
        else {
            resultsLabel?.text = "Tip-Off"
            detailLabel?.text = "\(game.time)"
        }
    }
    
}

