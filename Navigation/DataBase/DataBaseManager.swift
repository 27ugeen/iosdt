//
//  DataBaseManager.swift
//  Navigation
//
//  Created by GiN Eugene on 31/3/2022.
//

import Foundation
import CoreData

class DataBaseManager {
    
    static let shared = DataBaseManager()
    //==================Object Model========================
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "DataBaseModel", withExtension: "momd") else {
            fatalError("Unable to find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load Data Model")
        }
        
        return managedObjectModel
    }()
    //==================Store Coordinator========================
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let storeName = "DataBaseModel.sqlite"
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
        } catch {
            fatalError("Unable to load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    //==================Object Context========================
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    func getFavoritePost() -> FavoritePost? {
        let fetchRequest = FavoritePost.fetchRequest()
        do {
            let settings = try managedObjectContext.fetch(fetchRequest)
            if let set = settings.last {
                return set
            } else {
                return nil
            }
        } catch let error {
            print(error)
        }
        return nil
    }
}
