//
//  PlayerStatus.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/18/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import RealmSwift
import SWXMLHash

public class GamePlayerStats: Object {
    //V5
    public dynamic var playerName: String = ""
    public dynamic var playerCode: String = ""
    public dynamic var score: Int = 0
    public dynamic var totalRebounds: Int = 0
    public dynamic var steals: Int = 0
    public dynamic var assistances: Int = 0
    public dynamic var blockFavour: Int = 0
}

public extension GamePlayerStats {
    public func clone() -> GamePlayerStats {
        let newPlayerGameStatus = GamePlayerStats()
        newPlayerGameStatus.playerName = self.playerName
        newPlayerGameStatus.playerCode = self.playerCode
        newPlayerGameStatus.score = self.score
        newPlayerGameStatus.totalRebounds = self.totalRebounds
        newPlayerGameStatus.steals = self.steals
        newPlayerGameStatus.assistances = self.assistances
        newPlayerGameStatus.blockFavour = self.blockFavour
        return newPlayerGameStatus
    }
    public func parseStatusData(_ node: XMLIndexer) {
        do {
            self.playerCode = try node["PlayerCode"].value()
            self.playerName = try node["PlayerName"].value()
            self.score = try node["Score"].value()
        } catch {
//            print("error in score \(error) of player \(playerName) \(playerCode)")
        }
        do {
            self.totalRebounds = try node["TotalRebounds"].value()
        } catch {
//            print("error in rebounds \(error) of player \(playerName) \(playerCode)")
        }
        do {
            self.assistances = try node["Assistances"].value()
        } catch {
//            print("error in assists \(error) of player \(playerName) \(playerCode)")
        }
        do {
            self.steals = try node["Steals"].value()
        } catch {
//            print("error in steals \(error) of player \(playerName) \(playerCode)")
        }
        do {
            self.blockFavour = try node["BlocksFavour"].value()
        } catch {
//            print("error in blocks \(error) of player \(playerName) \(playerCode)")
        }
    }
}
