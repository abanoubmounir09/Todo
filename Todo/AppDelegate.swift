//
//  AppDelegate.swift
//  Todo
//
//  Created by pop on 5/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        do{
            let realm = try Realm()
        }catch{
            print(error)
        }
       
        
        return true
    }
    
}
    

    

