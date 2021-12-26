//
//  SceneDelegate.swift
//  Navigation
//
//  Created by GiN Eugene on 19.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let loginInspector = MyLoginFactory().createChecker()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
        
        let feedVC = FeedViewController()
        
        let loginVC = LogInViewController(delegate: loginInspector)
        loginVC.title = "Profile"
        
        let feedNavVC = UINavigationController(rootViewController: feedVC)
        feedNavVC.tabBarItem = UITabBarItem(title: feedVC.title, image: UIImage(systemName: "house.fill"), tag: 0)
        
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        
        loginNavVC.isNavigationBarHidden = true
        loginNavVC.tabBarItem = UITabBarItem(title: loginVC.title, image: UIImage(systemName: "person.fill"), tag: 1)
        
        tabBarController.viewControllers = [feedNavVC, loginNavVC]
        
        window?.rootViewController = tabBarController
    }
    
}

