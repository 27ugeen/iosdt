//
//  DataBaseManager.swift
//  Navigation
//
//  Created by GiN Eugene on 31/3/2022.
//

import Foundation
import UIKit
import CoreData

class DataBaseManager {
    
    static let shared = DataBaseManager()
    //==================Container========================
    let persistentContainer: NSPersistentContainer
    private lazy var backgroundContext = persistentContainer.newBackgroundContext()
    
    init() {
        let container = NSPersistentContainer(name: "DataBaseModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        self.persistentContainer = container
    }
    
    func getAllPosts() -> [FavoritePost?] {
        let fetchRequest = FavoritePost.fetchRequest()
        var favoritePostsArray: [FavoritePost]?
        do {
            favoritePostsArray = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return favoritePostsArray ?? []
    }
    
    func addPost(_ post: Post, completition: @escaping (String?) -> Void) {
        
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            let fetchRequest = FavoritePost.fetchRequest()
            
            do {
                let settings = try self.backgroundContext.fetch(fetchRequest)
                
                if settings.contains(where:  { $0.title == post.title }) {
                    completition("This post has already been added!")
                    print("This post has already been added!")
                } else {
                    if let newSet = NSEntityDescription.insertNewObject(forEntityName: "FavoritePost", into: self.backgroundContext) as? FavoritePost {
                        newSet.title = post.title
                        newSet.author = post.author
                        newSet.postDescription = post.description
                        newSet.likes = Int64(post.likes)
                        newSet.views = Int64(post.views)
                        newSet.stringImage = self.saveImageToDocuments(chosenImage: post.image)
                        
                        try self.backgroundContext.save()
                        print("Post has been added!")
                    } else {
                        fatalError("Unable to insert FavoritePost entity")
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func deletePost(favPost: FavoritePost) {
        let fetchRequest = FavoritePost.fetchRequest()
        
        do {
            let posts = try persistentContainer.viewContext.fetch(fetchRequest)
            posts.forEach {
                if ($0.title == favPost.title) {
                    persistentContainer.viewContext.delete($0)
                    deleteImageFromDocuments(imageUrl: URL(string: $0.stringImage ?? "") ?? URL(fileURLWithPath: ""))
                    print("Post \"\($0.title ?? "")\" has been removed from favorites")
                }
            }
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
// MARK: - FileManager func
extension DataBaseManager {
    func saveImageToDocuments(chosenImage: UIImage) -> String? {
        let imageData = chosenImage.jpegData(compressionQuality: .zero)
        
        do {
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let fileUrl = documentsUrl.appendingPathComponent(String.random())
            FileManager.default.createFile(atPath: fileUrl.path, contents: imageData, attributes: nil)
            return String(describing: fileUrl)
        }
        catch let error as NSError {
            print("Error is: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getImageFromDocuments(imageUrl: URL) -> UIImage? {
        do {
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let fileUrl = documentsUrl.appendingPathComponent(imageUrl.lastPathComponent)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    let imageData = try Data(contentsOf: fileUrl)
                    let image = UIImage(data: imageData)
                    return image
                } catch let error as NSError {
                    print("Error is: \(error.localizedDescription)")
                }
            } else {
                print("not found")
            }
        }
        catch let error as NSError {
            print("Error is: \(error.localizedDescription)")
        }
        return nil
    }
    
    func deleteImageFromDocuments(imageUrl: URL) {
        do {
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let fileUrl = documentsUrl.appendingPathComponent(imageUrl.lastPathComponent)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    try FileManager.default.removeItem(at: fileUrl)
                } catch let error as NSError {
                    print("Error is: \(error.localizedDescription)")
                }
            } else {
                print("not found")
            }
        }
        catch let error as NSError {
            print("Error is: \(error.localizedDescription)")
        }
    }
}
