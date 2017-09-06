//
//  UIColorExtensions.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {

    public static func getLeagueBarColor() -> UIColor {
        return Constants.season.getColor()
    }

    public static func getLeagueBackGroundColor() -> UIColor {
        return Constants.BackGroundColor
    }

}
