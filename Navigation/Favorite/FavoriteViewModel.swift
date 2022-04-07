//
//  FavoriteViewModel.swift
//  Navigation
//
//  Created by GiN Eugene on 31/3/2022.
//

import Foundation
import UIKit

protocol FavoriteViewModelOutputProtocol {
    func removePostFromFavorite(post: FavoritePost)
}

class FavoriteViewModel: FavoriteViewModelOutputProtocol {
    
    func removePostFromFavorite(post: FavoritePost) {
        DataBaseManager.shared.deletePost(favPost: post)
    }
}
