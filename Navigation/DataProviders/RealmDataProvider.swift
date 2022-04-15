//
//  RealmDataProvider.swift
//  Navigation
//
//  Created by GiN Eugene on 27/3/2022.
//

import Foundation
import RealmSwift

@objcMembers class CachedUser: Object {
    dynamic var id: String?
    dynamic var email: String?
    dynamic var password: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmDataProvider: DataProvider {
    weak var delegate: DataProviderDelegate?
    private var notificationToken: NotificationToken?
    
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("users.realm")
        return try? Realm(configuration: config)
    }
    
    init() {
        notificationToken = realm?.observe { [unowned self] _, _ in
            self.delegate?.usersDidChange(dataProivider: self)
        }
    }
    
    func getUsers() -> [User] {
        return realm?.objects(CachedUser.self).compactMap {
            guard let id = $0.id, let email = $0.email, let password = $0.password else { return nil }
            return User(id: id, email: email, password: password)
        } ?? []
    }
    
    func createUser(_ user: User) {
        let cachedUser = CachedUser()
        cachedUser.id = user.id
        cachedUser.email = user.email
        cachedUser.password = user.password
        
        try? realm?.write {
            realm?.add(cachedUser)
        }
    }
    
    func updateUser(_ user: User) {
        guard let cachedUser = realm?.object(ofType: CachedUser.self, forPrimaryKey: user.id) else { return }
        
        try? realm?.write {
            cachedUser.email = user.email
            cachedUser.password = user.password
        }
    }
    
    func deleteUser(_ user: User) {
        guard let cachedUser = realm?.object(ofType: CachedUser.self, forPrimaryKey: user.id) else { return }
        
        try? realm?.write {
            realm?.delete(cachedUser)
        }
    }
}
