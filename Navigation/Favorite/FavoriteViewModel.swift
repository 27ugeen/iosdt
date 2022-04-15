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
    func getFilteredPosts(postAuthor: String)
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
    var filteredPosts: [FavoritePostStub] = []
    
    func getAllFavoritePosts() {
        let postsArray = DataBaseManager.shared.getAllPosts()
        
        favoritePosts = []
        for post in postsArray {
            if let unwrappedPost = post {
                
                let newPostImage = DataBaseManager.shared.getImageFromDocuments(imageUrl: URL(string: unwrappedPost.stringImage ?? "") ?? URL(fileURLWithPath: ""))
                
                let newPost = FavoritePostStub(title: unwrappedPost.title ?? "",
                                               author: unwrappedPost.author ?? "",
                                               image: newPostImage ?? UIImage(),
                                               description: unwrappedPost.postDescription ?? "",
                                               likes: Int(unwrappedPost.likes),
                                               views: Int(unwrappedPost.views))
                
                favoritePosts.append(newPost)
            }
        }
    }
    
    func removePostFromFavorite(post: FavoritePostStub, index: Int) {
        DataBaseManager.shared.deletePost(favPost: post)
        favoritePosts.remove(at: index)
    }
    
    func getFilteredPosts(postAuthor: String) {
        
        self.getAllFavoritePosts()
        
        filteredPosts = []
        favoritePosts.forEach {
            if $0.author == postAuthor {
                filteredPosts.append($0)
            }
        }
        if filteredPosts.count > 0 {
            favoritePosts = filteredPosts
        } else {
            favoritePosts = []
            print("No such author found")
        }
    }
}
