//
//  RealmDBManager.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/21/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmDBManager {

    public static let sharedInstance = RealmDBManager()

    private let realmConfiguration: Realm.Configuration = Realm.Configuration.defaultConfiguration

    private init() {}

    //Game
    public func getGames(ofSeason season: String) -> Results<Game>? {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let predicate = NSPredicate(format: "seasonCode = %@", season)
            let sortProperties = [SortDescriptor(keyPath: "date", ascending: true),
                                  SortDescriptor(keyPath: "time", ascending: true)]
            let table = realm.objects(Game.self).filter(predicate).sorted(by: sortProperties)
            return table
        } catch {
            return nil
        }
    }

    public func getGame(withCode code: String) -> Game? {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let predicate = NSPredicate(format: "gameCode = %@", code)
            let result = realm.objects(Game.self).filter(predicate)
            return result.first
        } catch {
            return nil
        }
    }

    public func addGameDataToRealm(game: Game) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let predicate = NSPredicate(format: "gameCode = %@", game.gameCode)
            let result = realm.objects(Game.self).filter(predicate)
            if result.count == 0 {
                try realm.write {
                    realm.add(game, update: true)
                }
            } else {
                try realm.write {
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
        } catch {
            return
        }
    }

    public func updateScoreFor(_ game: Game, homeScore: Int, awayScore: Int) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let predicate = NSPredicate(format: "gameCode = %@", game.gameCode)
            let result = realm.objects(Game.self).filter(predicate)
            guard let realmGame = result.first
                else { return }
            do {
                try realm.write {
                    realmGame.played = true
                    realmGame.homeScore = homeScore
                    realmGame.awayScore = awayScore
                }
            } catch {
                print("Failed to update results in Realm")
            }
        } catch {
            return
        }
    }

    public func updateGameTeamsDetailFor(gameWithCode code: String, localTeam: GameTeamDetail?, roadTeam: GameTeamDetail?) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let predicate = NSPredicate(format: "gameCode = %@", code)
            let result = realm.objects(Game.self).filter(predicate)
            guard let realmGame = result.first else {
                print("Failed to update Game with code \(code)")
                return
            }
            try realm.write {
                realmGame.localTeamGameDetail = localTeam
                realmGame.roadTeamGameDetail = roadTeam
            }
        } catch {
            return
        }
    }

    //Team
    public func getTeams(ofSeason season: String) -> Results<Team>? {
        do {
            let realm = try Realm(configuration: realmConfiguration)

            let predicate = NSPredicate(format: "seasonCode = %@", season)
            let sortProperties = [SortDescriptor(keyPath: "name", ascending: true)]
            let table = realm.objects(Team.self).filter(predicate).sorted(by: sortProperties)
            return table
        } catch {
            return nil
        }
    }

    public func addTeamDataToRealm(_ team: Team) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                realm.add(team, update: true)
            }
        } catch {
            return
        }
    }

    //Player
    public func getPlayer(withCode code: String) -> Player? {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let predicate = NSPredicate(format: "code = %@", code)
            let result = realm.objects(Player.self).filter(predicate)
            return result.first
        } catch {
            return nil
        }
    }

    public func addPlayer(_ player: Player) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                realm.add(player, update: true)
            }
        } catch {
            return
        }
    }

}
