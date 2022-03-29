//
//  DataProvider.swift
//  Navigation
//
//  Created by GiN Eugene on 27/3/2022.
//

import Foundation

protocol DataProviderDelegate: AnyObject {
    func usersDidChange(dataProivider: DataProvider)
}

protocol DataProvider: AnyObject {
    var delegate: DataProviderDelegate? { get set }
    func getUsers() -> [User]
    func createUser(_ user: User)
    func updateUser(_ user: User)
    func deleteUser(_ user: User)
}
