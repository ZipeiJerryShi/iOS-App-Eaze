//
//  DataController.swift
//  Eaze
//
//  Created by Jerry Shi on 3/24/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    static let sharedInstance = DataController()
    var writerManagedObjectContext: NSManagedObjectContext
    var managedObjectParentContext: NSManagedObjectContext
    var managedObjectContext: NSManagedObjectContext
    var psc: NSPersistentStoreCoordinator
    
    fileprivate override init() {
        print("INITIALIZING PERSISTENT STORE COORDINATOR")
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Eaze", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        self.psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.writerManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.writerManagedObjectContext.persistentStoreCoordinator = self.psc
        self.managedObjectParentContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectParentContext.parent = self.writerManagedObjectContext
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.managedObjectContext.parent = self.managedObjectParentContext
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        do {
            try self.psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    func deleteAndRecreateStore() {
        print("DELETING AND RECREATING PERSISTENT STORE COORDINATOR")
        guard let persistentStore = self.psc.persistentStores.last else {
            return
        }
        
        let url = self.psc.url(for: persistentStore)
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        self.writerManagedObjectContext.performAndWait {
            self.writerManagedObjectContext.reset()
            self.managedObjectParentContext.reset()
            self.managedObjectContext.reset()
            do {
                try self.psc.remove(persistentStore)
                try FileManager.default.removeItem(at: url)
                try self.psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
                print("DELETED AND RECREATED PERSISTENT STORE")
            } catch {
                fatalError("ERROR DELETING AND RECREATING STORE\n: \(error)")
            }
        }
    }
}
