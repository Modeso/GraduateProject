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
    
    private let realmConfiguration: Realm.Configuration = Realm.Configuration.defaultConfiguration
    private var queue = 0
    
    private init() {
    }
    
    //Game
    func getGames(ofSeason season: String) -> Results<Game> {
        let realm = try! Realm(configuration: realmConfiguration)
        let predicate = NSPredicate(format: "seasonCode = %@", season)
        let sortProperties = [SortDescriptor(keyPath: "date", ascending: true), SortDescriptor(keyPath: "time", ascending: true)]
        let table = realm.objects(Game.self).filter(predicate).sorted(by: sortProperties)
        return table
    }
    
    func getGame(withCode code: String) -> Game? {
        let realm = try! Realm(configuration: realmConfiguration)
        let predicate = NSPredicate(format: "gameCode = %@", code)
        let result = realm.objects(Game.self).filter(predicate)
        return result.first
    }
    
    func addGameDataToRealm(game: Game){
        DispatchQueue.global().async {[weak self] in
            guard let realmConfiguration = self?.realmConfiguration else { return }
            let realm = try! Realm(configuration: realmConfiguration)
            let predicate = NSPredicate(format: "gameCode = %@", game.gameCode)
            let result = realm.objects(Game.self).filter(predicate)
            if result.count == 0 {
                try! realm.write {
                    realm.add(game, update: true)
                }
            }
            else {
                try! realm.write {
                    let realmGame = result.first
                    realmGame?.awayCode = game.awayCode
                    realmGame?.awayTv = game.awayTv
                    realmGame?.date = game.date
                    realmGame?.homeCode = game.homeCode
                    realmGame?.homeTv = game.homeTv
                    realmGame?.round = game.round
                    realmGame?.played = game.played
                    realmGame?.time = game.time
                    realmGame?.seasonCode = game.seasonCode
                }
            }
        }
    }
    
    func updateScoreFor(_ game:Game, homeScore: Int, awayScore: Int){
        guard let realmGame = self.getGame(withCode: game.gameCode)
            else { return }
        do {
            let realm = try! Realm(configuration: realmConfiguration)
            try realm.write {
                realmGame.played = true
                realmGame.homeScore = homeScore
                realmGame.awayScore = awayScore
            }
        } catch {
            print("Failed to update results in Realm")
        }
    }
    
    func updateGameTeamsDetailFor(gameWithCode code: String, localTeam: GameTeamDetail?, roadTeam: GameTeamDetail?) {
        DispatchQueue.global().async {[weak self] in
            guard let realmConfiguration = self?.realmConfiguration else { return }
            let realm = try! Realm(configuration: realmConfiguration)
            guard let realmGame = self?.getGame(withCode: code)
                else {
                    print("Updating Details Failed")
                    return
            }
            try! realm.write {
                realmGame.localTeamGameDetail = localTeam
                realmGame.roadTeamGameDetail = roadTeam
            }
        }
    }
    
    //Team
    func getTeams(ofSeason season: String) -> Results<Team> {
        let realm = try! Realm(configuration: realmConfiguration)
        let predicate = NSPredicate(format: "seasonCode = %@", season)
        let sortProperties = [SortDescriptor(keyPath: "name", ascending: true)]
        let table = realm.objects(Team.self).filter(predicate).sorted(by: sortProperties)
        return table
    }
    
    func addTeamDataToRealm(_ team: Team){
        let realm = try! Realm(configuration: realmConfiguration)
        try! realm.write {
            realm.add(team, update: true)
        }
    }
    
    //Player
    func getPlayer(withCode code: String) -> Player? {
        let realm = try! Realm(configuration: realmConfiguration)
        let predicate = NSPredicate(format: "code = %@", code)
        let result = realm.objects(Player.self).filter(predicate)
        return result.first
    }
    
    func addPlayer(_ player:Player){
        DispatchQueue.global().async {[weak self] in
            guard let realmConfiguration = self?.realmConfiguration else { return }
            let realm = try! Realm(configuration: realmConfiguration)
            try! realm.write {
                realm.add(player, update: true)
            }
        }
    }
    
}
