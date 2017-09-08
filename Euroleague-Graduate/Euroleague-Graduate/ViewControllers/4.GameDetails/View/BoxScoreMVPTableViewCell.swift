//
//  BoxScoreMVPTableViewCell.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/17/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class BoxScoreMVPTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var homePlayerLabel: UILabel!
    @IBOutlet fileprivate weak var homePlayerPoints: UILabel!
    @IBOutlet fileprivate weak var typeLabel: UILabel!
    @IBOutlet fileprivate weak var awayPointsLabel: UILabel!
    @IBOutlet fileprivate weak var awayPlayerLabel: UILabel!

    var boxScore: BoxScoreInfo? {
        didSet {
            updateUI()
        }
    }

}

fileprivate extension BoxScoreMVPTableViewCell {

    func updateUI() {
        guard let boxScore = self.boxScore else {
            return
        }
        homePlayerLabel.text = boxScore.homeTeamPlayerName
        homePlayerPoints.text = boxScore.homeTeamPlayerPointText
        typeLabel.text = boxScore.name
        awayPlayerLabel.text = boxScore.guestTeamPlayerName
        awayPointsLabel.text = boxScore.guestTeamPlayerPointText
    }

}
