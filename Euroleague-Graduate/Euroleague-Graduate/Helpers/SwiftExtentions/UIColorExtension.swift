//
//  UIColorExtensions.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    static func getLeagueBarColor() -> UIColor {
        return Constants.season.getColor()
    }

    static func getLeagueBackGroundColor() -> UIColor {
        return Constants.BackGroundColor
    }

}
