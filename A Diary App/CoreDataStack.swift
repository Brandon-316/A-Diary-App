//
//  CoreDataStack.swift
//  TodoList
//
//  Created by Brandon Mahoney on 9/20/17.
//  Copyright © 2017 Brandon Mahoney. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "A_Diary_App")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
}


extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}























