//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 30/3/2022.
//

import UIKit

class FavoriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.title = "Favorite"
        self.view.backgroundColor = .systemBlue
        
        let favoritePost = DataBaseManager.shared.getFavoritePost()
        print("Post: \(String(describing: favoritePost))")
    }

}
