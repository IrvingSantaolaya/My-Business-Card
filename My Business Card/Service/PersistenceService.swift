//
//  PersistenceService.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/13/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    // MARK: - Core Data stack
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Create persistent container to use throughout app
    static var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "My_Business_Card")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                // There was an error
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    // Save whats inside the container
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            
            do {
                
                try context.save()
                
            } catch {
                // There was an error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
