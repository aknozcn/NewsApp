//
//  PersistentStorage .swift
//  NewsApp
//
//  Created by Akin O. on 2.06.2021.
//

import Foundation
import CoreData

final class PersistentStorage {

    
    private init() { }
    
    lazy var context = persistentContainer.viewContext
    static let shared = PersistentStorage()

    
// MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "NewsApp")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

// MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
    
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {

        do {
            guard let result = try PersistentStorage.shared.context.fetch(CDNews.fetchRequest()) as? [T] else { return nil }
            return result
        } catch let error {
            debugPrint(error)
        }
        
        return nil
    }
}

