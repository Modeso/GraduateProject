//
//  SwiftExtentions.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/16/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UIColor {
    
    static func getLeagueBarColor() -> UIColor{
        return LeaguesCommenObjects.season.getColor()
    }
    
    static func getLeagueBackGroundColor() -> UIColor {
        return LeaguesCommenObjects.BackGroundColor
    }
    
}

extension UIView {
    
    func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func roundCornerMask() {
        // bezier path to setup round coner for topleft, bottom left
        let bezierPath = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: [.bottomLeft, .topLeft],
                                      cornerRadii: CGSize(width: self.bounds.height * 0.5, height: self.bounds.height * 0.5))
        let shape = CAShapeLayer()
        shape.path = bezierPath.cgPath
        self.layer.mask = shape
    }
}

extension String {
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}

extension Date {
    
    func convertStringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: date)!
    }
    
    func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
}

public extension Float {

    static var random:Float {
        get {
            return Float(arc4random()) / Float(UInt32.max)
        }
    }
    
    static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
