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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func updateUI() {
        guard let game = self.game
            else { return }
        addSeparatorLineToTop()
        homeImageView?.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "emptyImage"))
        awayImageView?.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "emptyImage"))
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

extension UITableViewCell {
    
    func addSeparatorLineToTop(){
        let lineFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 5)
        let line = UIView(frame: lineFrame)
        line.backgroundColor = UIColor(red: 60.0/255, green: 60.0/255, blue: 60.0/255, alpha: 1)
        addSubview(line)
    }
}
