//
//  AppDelegate.swift
//  Todoey
//
//  Created by Panayiotis Lee Sapounakis on 04/04/2018.
//  Copyright © 2018 Dev Lee Apps. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            
            let _ = try Realm()
            
        } catch {
        
            print("Error initialising new realm, \(error)")
        
        }
        
        return true
    }

}

