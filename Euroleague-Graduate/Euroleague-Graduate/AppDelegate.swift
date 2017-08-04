//
//  AppDelegate.swift
//  Euroleague-Graduate
//
//  Created by Mohammed Elsammak on 7/7/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { (migration, oldVersion) in
                if oldVersion < 1 {
                    migration.enumerateObjects(ofType: Game.className()) { (oldObject, newObject) in
                            newObject!["awayCode"] = ""
                            newObject!["homeCode"] = ""
                    }
                }
                
                if oldVersion < 2 {
                    migration.enumerateObjects(ofType: Team.className()) { (oldObject, newObject) in
                        newObject!["coachName"] = ""
                        newObject!["coachCountry"] = ""
                        newObject!["rosters"] = List<Player>()
                    }
                }
                
                if oldVersion < 3 {
                    migration.enumerateObjects(ofType: Team.className()) { (oldObject, newObject) in
                        migration.enumerateObjects(ofType: Player.className()) { (oldObject, newObject) in
                            newObject!["primaryKeyProperty"] = "name"
                        }
                        let coach = Player()
                        coach.name = oldObject!["coachName"] as! String
                        coach.countryName = oldObject!["coachCountry"] as! String
                        newObject!["coach"] = coach
                    }
                }
                
                if oldVersion < 4 {
                    migration.enumerateObjects(ofType: Player.className()){ (oldObject, newObject) in
                        newObject!["primaryKeyProperty"] = "code"
                        
                    }
                }
                
                
                
        })
        Realm.Configuration.defaultConfiguration = config
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

