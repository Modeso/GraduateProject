//
//  StringExtentions.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

public extension String {

    public func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }

    public mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    public func convertStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: self) ?? Date()
    }

}
