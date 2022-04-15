//
//  SimpleDateProvider.swift
//  Navigation
//
//  Created by GiN Eugene on 27/3/2022.
//

import Foundation

final class SimpleDataProvider: DataProvider {
    
    weak var delegate: DataProviderDelegate?
    private var users: [User] = []
    
    func getUsers() -> [User] {
        return users
    }
    
    func createUser(_ user: User) {
        users.append(user)
        delegate?.usersDidChange(dataProivider: self)
    }
    
    func updateUser(_ user: User) {
        if let index = users.firstIndex(where: {$0.id == user.id }) {
            users.remove(at: index)
            users.insert(user, at: index)
            delegate?.usersDidChange(dataProivider: self)
        }
    }
    
    func deleteUser(_ user: User) {
        if let index = users.firstIndex(where: {$0.id == user.id }) {
            users.remove(at: index)
            delegate?.usersDidChange(dataProivider: self)
        }
    }
}
