//
//  User.swift
//  Navigation
//
//  Created by GiN Eugene on 28/10/21.
//

import Foundation
import UIKit

protocol UserServiceProtocol {
    func showUserInfo(userName: String) -> User
}


class User {
    
    var userFullName: String
    var userAvatar: UIImage?
    var isUserOnline: Bool?
    
    init(userFullName: String) {
        self.userFullName = userFullName
    }
    
}

class CurrentUserService: UserServiceProtocol {
    var user: User?
    
    func showUserInfo(userName: String) -> User {
        user = User(userFullName: userName)
        return user ?? User(userFullName: "Not found \"\(userName)\" user")
    }
}

class TestUserService: UserServiceProtocol {
    var user: User?
    
    func showUserInfo(userName: String) -> User {
        user = User(userFullName: "testUser")
        user!.isUserOnline = true
        user!.userAvatar = UIImage(systemName: "person.fill.questionmark")
        return user!
    }
}
