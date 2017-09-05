//
//  UIViewExtentions.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    public func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }

    public func roundCornerMask() {
        // bezier path to setup round coner for topleft, bottom left
        let bezierPath = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: [.bottomLeft, .topLeft],
                                      cornerRadii: CGSize(width: self.bounds.height * 0.5, height: self.bounds.height * 0.5))
        let shape = CAShapeLayer()
        shape.path = bezierPath.cgPath
        self.layer.mask = shape
    }

}
