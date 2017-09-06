//
//  FloatExtention.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

public extension Float {

    public static var random: Float {
        return Float(arc4random()) / Float(UInt32.max)
    }

    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
