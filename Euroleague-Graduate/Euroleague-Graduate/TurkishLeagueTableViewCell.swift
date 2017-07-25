//
//  TurkishLeagueTableViewCell.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/24/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import  SDWebImage

class TurkishLeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var homeImageView: UIImageView!
    
    @IBOutlet weak var awayImageView: UIImageView!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    var game: GameData? {
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func updateUI() {
        if game != nil {
            homeImageView?.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "emptyImage"))
            awayImageView?.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "emptyImage"))
            if (game?.played)! {
                resultsLabel?.text = "\((game?.homeScore)!) : \((game?.awayScore)!)"
                detailLabel?.text = "\((game?.homeTv)!)        \((game?.awayTv)!)"
            }
            else {
                resultsLabel?.text = "Tip-Off"
                detailLabel?.text = "\((game?.time)!)"
            }
        }
    }

}
