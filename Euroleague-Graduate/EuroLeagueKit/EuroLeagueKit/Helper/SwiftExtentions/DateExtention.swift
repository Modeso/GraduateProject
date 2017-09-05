//
//  DateExtentions.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation

public extension Date {

    public func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }

}
