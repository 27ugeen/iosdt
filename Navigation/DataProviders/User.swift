//
//  User.swift
//  Navigation
//
//  Created by GiN Eugene on 27/3/2022.
//

import Foundation

final class User {
    
    let id: String
    let email: String
    let password: String
    
    init(id: String = UUID().uuidString, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}
