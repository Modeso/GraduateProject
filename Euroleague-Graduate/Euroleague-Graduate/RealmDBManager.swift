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
    
    private var realm: Realm
    private var queue = 0
    
    private init() {
        realm = try! Realm()
    }
    
    func getGames() -> Results<GameData> {
        let sortProperties = [SortDescriptor(keyPath: "date", ascending: true), SortDescriptor(keyPath: "time", ascending: true)]
        let table = realm.objects(GameData.self).sorted(by: sortProperties)
        return table
    }
    
    func addDataToRealm(game: GameData){
            try! realm.write {
                realm.add(game, update: true)
            }
    }
    
    func updateScoreFor(_ game:GameData, homeScore: Int, awayScore: Int){
            try! realm.write {
                game.homeScore = homeScore
                game.awayScore = awayScore
            }
    }
    
}
