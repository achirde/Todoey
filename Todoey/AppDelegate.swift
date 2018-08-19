//
//  AppDelegate.swift
//  Todoey
//
//  Created by Arkadipra De on 8/12/18.
//  Copyright © 2018 Achirangshu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        }catch{
            print("Error in Realm,\(error)")
        }
        
        return true
    }

    


}

