//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Evgeniy on 30.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol IStorageManager
{
    var masterContext: NSManagedObjectContext { get }
    var managedObjectModel: NSManagedObjectModel { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator? { get }
    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
}

final class StorageManager: IStorageManager
{
    // MARK: - IStorageManager
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let model = NSManagedObjectModel(contentsOf: self.modelURL)
        assert(model != nil, "Can't initialize managedObjectModel")
        return model!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do
        {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeURL, options: nil)
        }
        catch
        {
            assertionFailure("Can't add persistent store to coordinator. Error: \(error)")
        }
        return coordinator
    }()
    
    lazy var masterContext: NSManagedObjectContext = {
        let ctx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        guard let coordinator = self.persistentStoreCoordinator else
        {
            assertionFailure("Can't initialize persistent store!")
            return ctx
        }
        ctx.persistentStoreCoordinator = coordinator
        ctx.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        ctx.undoManager = nil
        return ctx
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let ctx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        ctx.parent = self.masterContext
        ctx.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        ctx.undoManager = nil
        return ctx
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        let ctx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        ctx.parent = self.mainContext
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        ctx.undoManager = nil
        return ctx
    }()
    
    // MARK: - Private properties
    
    // MARK: Lazy
    
    private lazy var modelURL: URL = {
        let url = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")
        assert(url != nil, "Can't obtain url for managed object model!")
        return url!
    }()
    
    private lazy var storeURL: URL = {
        let docsDir = FileManager.default.urls(for: .documentDirectory,
                                               in: .userDomainMask).first!
        
        return docsDir.appendingPathComponent("Store" + ".sqlite")
    }()
    
    // MARK: Stored
    
    private let managedObjectModelName = "ChatModel"
}
