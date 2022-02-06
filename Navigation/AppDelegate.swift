//
//  AppDelegate.swift
//  Navigation
//
//  Created by GiN Eugene on 19.07.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        for config in AppConfiguration.allCases {
            let url = config.rawValue
            NetworkService.startTask(requestUrl: url)
        }
        
        return true
    }
}
