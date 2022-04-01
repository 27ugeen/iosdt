//
//  FavoriteViewModel.swift
//  Navigation
//
//  Created by GiN Eugene on 31/3/2022.
//

import Foundation
import UIKit

protocol FavoriteViewModelOutputProtocol {
    func getAllFavoritePosts()
}

struct FavoritePostStub {
    let title: String
    let author: String
    let image: UIImage
    let description: String
    let likes: Int
    let views: Int
}

class FavoriteViewModel: FavoriteViewModelOutputProtocol {
    
    var favoritePosts: [FavoritePostStub] = []
    
    func getAllFavoritePosts() {
        let postsArray = DataBaseManager.shared.getAllPosts()
        
        favoritePosts = []
        for post in postsArray {
            if let unwrappedPost = post {
                let newPost = FavoritePostStub(title: unwrappedPost.title ?? "", author: unwrappedPost.author ?? "", image: UIImage(data: unwrappedPost.image ?? Data()) ?? UIImage(), description: unwrappedPost.postDescription ?? "", likes: Int(unwrappedPost.likes), views: Int(unwrappedPost.views))
                
                favoritePosts.append(newPost)
            }
        }
    }
}
