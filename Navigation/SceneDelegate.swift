//
//  SceneDelegate.swift
//  Navigation
//
//  Created by GiN Eugene on 19.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let feedViewModel = FeedViewModel()
    let loginViewModel = LoginViewModel()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let loginVC = LogInViewController(loginViewModel: loginViewModel)
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        loginNavVC.isNavigationBarHidden = true
        
        window?.rootViewController = loginNavVC
    }
}
