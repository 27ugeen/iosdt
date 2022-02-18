//
//  Checker.swift
//  Navigation
//
//  Created by GiN Eugene on 31/10/21.
//

import Foundation

class Checker {
    
    static let instance = Checker()
    
    private let login = "User"
    
    private let pswd = "StrongPassword"
    
    private init() {}
    
    func checkLoginPassword (userLogin: String, userPassword: String) -> Bool {
        guard userLogin.hash == login.hash && userPassword.hash == pswd.hash else {
            print("Incorrect login or password!")
            return false
        }
            print("Correct!")
        return true
    }
}
