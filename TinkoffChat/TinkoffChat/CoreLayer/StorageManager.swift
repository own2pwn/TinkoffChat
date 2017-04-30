//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Evgeniy on 30.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataWorker
{
    var masterContext: NSManagedObjectContext { get }
}

protocol IStorageManager
{
    var managedObjectModel: NSManagedObjectModel? { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator? { get }
    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
}

final class StorageManager: IStorageManager
{
    // MARK: - IStorageManager
    
    var managedObjectModel: NSManagedObjectModel?
    {
        if _managedObjectModel == nil
        {
            guard let url = modelURL else { return nil }
            _managedObjectModel = NSManagedObjectModel(contentsOf: url)
        }
        return _managedObjectModel
    }
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    {
        if _persistentStoreCoordinator == nil
        {
            guard let model = self.managedObjectModel else
            {
                assertionFailure("Can't initialize managedObjectModel")
                return nil
            }
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            do
            {
                try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                    configurationName: nil,
                                                                    at: self.storeURL, options: nil)
            }
            catch
            {
                assertionFailure("Can't add persistent store to coordinator. Error: \(error)")
            }
        }
        return _persistentStoreCoordinator
    }
    
    var masterContext: NSManagedObjectContext
    {
        if let ctx = _masterContext { return ctx }
        else
        {
            let ctx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            guard let coordinator = persistentStoreCoordinator else
            {
                assertionFailure("Can't initialize persistent store!")
                return ctx
            }
            ctx.persistentStoreCoordinator = coordinator
            ctx.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            ctx.undoManager = nil
            _masterContext = ctx
            return ctx
        }
    }
    
    var mainContext: NSManagedObjectContext
    {
        if let ctx = _mainContext { return ctx }
        else
        {
            let ctx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            guard let parentContext = _masterContext else
            {
                assertionFailure("Can't initialize parentContext!")
                return ctx
            }
            ctx.parent = parentContext
            ctx.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            ctx.undoManager = nil
            _mainContext = ctx
            return ctx
        }
    }
    
    var saveContext: NSManagedObjectContext
    {
        if let ctx = _mainContext { return ctx }
        else
        {
            let ctx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            guard let parentContext = _mainContext else
            {
                assertionFailure("Can't initialize mainContext!")
                return ctx
            }
            ctx.parent = parentContext
            ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            ctx.undoManager = nil
            _mainContext = ctx
            return ctx
        }
    }
    
    // MARK: - Private properties
    
    private let managedObjectModelName = "ChatModel"
    
    private var modelURL: URL?
    {
        guard let url = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else
        {
            assertionFailure("Can't obtain url for managed object model!")
            return nil
        }
        return url
    }
    
    private var storeURL: URL
    {
        let docsDir = FileManager.default.urls(for: .documentDirectory,
                                               in: .userDomainMask).first!
        
        return docsDir.appendingPathComponent("Store" + ".sqlite")
    }
    
    private var _managedObjectModel: NSManagedObjectModel?
    
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    private var _masterContext: NSManagedObjectContext?
    
    private var _mainContext: NSManagedObjectContext?
    
    private var _saveContext: NSManagedObjectContext?
}
