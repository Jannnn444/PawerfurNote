//
//  CoreDataManager.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import CoreData

class CoreDataManager {
    
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "NotesContainer")
    }

    func loadCoreData(completion: @escaping (Bool) -> Void) {
        container.loadPersistentStores { description, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Core Data loading error: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}
