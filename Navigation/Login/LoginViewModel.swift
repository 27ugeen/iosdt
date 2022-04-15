//
//  LoginViewModel.swift
//  Navigation
//
//  Created by GiN Eugene on 16/2/2022.
//

import Foundation
import UIKit

enum AuthorizationStrategy {
    case logIn
    case newUser
}

protocol LoginViewInputProtocol: AnyObject {
    func userTryAuthorize(withStrategy: AuthorizationStrategy)
}

protocol LoginViewOutputProtocol: AnyObject {
    func signInUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void)
    func createUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void)
}

final class LoginViewModel: LoginViewOutputProtocol {
    
    let dataProvider: DataProvider = RealmDataProvider()
    weak var view: LoginViewInputProtocol?
    
    func getCurrentUser(_ userId: String) -> User {
        return dataProvider.getUsers().first(where: { $0.id == userId }) ?? User(email: "nil", password: "nil")
    }
    
    func createUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void) {
        let users = dataProvider.getUsers()
        
        for user in users {
            if user.email == userLogin {
                completition("Email already exists")
                return
            }
        }
        if !userLogin.isValidEmail {
            completition("Incorrect email format")
            return
        }
        if userPassword.count < 6 {
            completition("Pasword must be at least 6 characters long")
            return
        }
        
        let newUser = User(email: userLogin, password: userPassword)
        dataProvider.createUser(newUser)
        UserDefaults.standard.set(newUser.id, forKey: "userId")
        UserDefaults.standard.set(true, forKey: "isSignedUp")
    }
    
    func signInUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void) {
        let users = dataProvider.getUsers()
        
        if users.contains(where: { user in
            user.email == userLogin && user.password.hash == userPassword.hash
        }) {
            for user in users {
                UserDefaults.standard.set(user.id, forKey: "userId")
                UserDefaults.standard.set(true, forKey: "isSignedUp")
            }
            print("Sign in result: \(userLogin)")
        } else {
            completition("Incorrect login or password")
        }
    }
}
