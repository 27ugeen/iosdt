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
    //==================Container========================
//    private let persistentContainer: NSPersistentContainer
//
//    init() {
//    let container = NSPersistentContainer(name: "DataBaseModel")
//    container.loadPersistentStores { description, error in
//       if let error = error {
//           fatalError("Unable to load persistent stores: \(error)")
//       }
//    }
//    self.persistentContainer = container
//    }
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
    
    func getAllPosts() -> [FavoritePost?] {
        let fetchRequest = FavoritePost.fetchRequest()
        var favoritePostsArray: [FavoritePost]?
        
        do {
            favoritePostsArray = try managedObjectContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        
        return favoritePostsArray ?? []
    }
    
    func addPost(_ post: Post, completition: @escaping (String?) -> Void) {
        let fetchRequest = FavoritePost.fetchRequest()
        do {
            let settings = try managedObjectContext.fetch(fetchRequest)
            
            if settings.contains(where:  { $0.title == post.title }) {
                completition("This post has already been added!")
            } else {
                if let newSet = NSEntityDescription.insertNewObject(forEntityName: "FavoritePost", into: managedObjectContext) as? FavoritePost {
                    newSet.title = post.title
                    newSet.author = post.author
                    newSet.image = post.image.jpegData(compressionQuality: .zero)
                    newSet.postDescription = post.description
                    newSet.likes = Int64(post.likes)
                    newSet.views = Int64(post.views)
                    
                    print("Post has been added!")
                } else {
                    fatalError("Unable to insert FavoritePost entity")
                }
            }
                
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
