//
//  AbstractViewModel.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 9/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

protocol AbstractViewModel {

    func getData(withData data: [Any]?, completion: @escaping ([NSArray]?) -> Void)

}
