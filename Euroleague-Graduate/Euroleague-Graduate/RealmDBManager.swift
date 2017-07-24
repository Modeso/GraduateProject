//
//  RealmDBManager.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/21/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDBManager {
    
    static let sharedInstance = RealmDBManager()
    
    private let realm: Realm
    
    private var count = 0
    
    private init() {
        realm = try! Realm()
    }
    
    func getDataFromRealm() -> Results<GameData> {
        print("Going to get Data")
        print(count)
        let sortProperties = [SortDescriptor(keyPath: "date", ascending: true), SortDescriptor(keyPath: "time", ascending: true)]
        let table = realm.objects(GameData.self).sorted(by: sortProperties)
        
//        table.forEach { (gamedata) in
//            print("dddddd")
//        }
//        let item = table.first
//        print("\(item?.gameNumber)")
//        print("\(item?.awayTv)")

        return table
    }
    
    func addDataToRealm(game: GameData){
        try! realm.write {
            realm.add(game, update: true)
            count += 1
        }
    }
    
    func updateScoreFor(_ game:GameData, homeScore: Int, awayScore: Int){
        try! realm.write {
            game.homeScore = homeScore
            game.awayScore = awayScore
        }
    }
    
}
