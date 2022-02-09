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
        
        let appConfiguration: AppConfiguration = .people
        
        let url = appConfiguration.rawValue
        NetworkService.startTask(requestUrl: url)
        
        return true
    }
}
