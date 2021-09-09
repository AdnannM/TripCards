//
//  AppDelegate.swift
//  TripCards
//
//  Created by Adnann Muratovic on 06.09.21.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuaration = ParseClientConfiguration {
            $0.applicationId = "OsBh7CxR9JgSsyV5As1iViDVjGh1BS4bWn4LiyFs"
            $0.clientKey = "z7vnFfzegyvGAnNm0PZ9CGWGY1iD4ml9rUZ2s6X9"
            $0.server = "https://parseapi.back4app.com"
        }
        
        Parse.initialize(with: configuaration)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

