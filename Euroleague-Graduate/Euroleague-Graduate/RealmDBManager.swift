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
    
    //Game
    func getGames() -> Results<Game> {
        let sortProperties = [SortDescriptor(keyPath: "date", ascending: true), SortDescriptor(keyPath: "time", ascending: true)]
        let table = realm.objects(Game.self).sorted(by: sortProperties)
        return table
    }
    
    func addGameDataToRealm(game: Game){
        print("game.gameNumber \(game.gameNumber)")
//        let predicate = NSPredicate(format: "gameNumber = %@", "\(game.gameNumber)")
//        let result = realm.objects(Player.self).filter(predicate)
//        if result.count == 0 {
            try! realm.write {
                realm.add(game, update: true)
            }
//        }
    }
    
    func updateScoreFor(_ game:Game, homeScore: Int, awayScore: Int){
        try! realm.write {
            game.played = true
            game.homeScore = homeScore
            game.awayScore = awayScore
        }
    }
    
    func updateGameTeamsDetailFor(_ game: Game, localTeam: GameTeamDetail?, roadTeam: GameTeamDetail?) {
        try! realm.write {
            game.localTeamGameDetail = localTeam
            game.roadTeamGameDetail = roadTeam
        }
    }
    
    //Team
    func getTeams() -> Results<Team> {
        let sortProperties = [SortDescriptor(keyPath: "name", ascending: true)]
        let table = realm.objects(Team.self).sorted(by: sortProperties)
        return table
    }
    
    func addTeamDataToRealm(_ team: Team){
        try! realm.write {
            realm.add(team, update: true)
        }
    }
    
    //Player
    func getPlayer(withCode code: String) -> Player? {
        let predicate = NSPredicate(format: "code = %@", code)
        let result = realm.objects(Player.self).filter(predicate)
        return result.first
    }
    
    func addPlayer(_ player:Player){
        try! realm.write {
            realm.add(player, update: true)
        }
    }
    
}
