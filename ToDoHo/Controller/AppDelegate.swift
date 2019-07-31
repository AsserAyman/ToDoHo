//
//  AppDelegate.swift
//  ToDoHo
//
//  Created by Asser on 7/21/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      //  print(Realm.Configuration.defaultConfiguration.fileURL!)
        do{
         _ = try Realm()
        } catch {
            print("Error initializing new Realm \(error)")
        }
        return true
    }

   
 

}

