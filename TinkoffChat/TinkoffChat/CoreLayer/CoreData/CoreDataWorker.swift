//
//  CoreDataWorker.swift
//  TinkoffChat
//
//  Created by Evgeniy on 30.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import CoreData

protocol ICoreDataWorker
{
    func updateOrInsert<Object: NSManagedObject>(object: Object,
                                                 completion: ((Error?) -> Void)?)
    
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity,
                                                          completion: ((Error?) -> Void)?)
    
    func get<Entity: ManagedObjectConvertible>(with predicate: NSPredicate?,
                                               sortDescriptors: [NSSortDescriptor]?,
                                               fetchLimit: Int?,
                                               completion: @escaping (Result<[Entity]>) -> Void)
    
    func executeFetchRequest(_ request: NSFetchRequest<NSFetchRequestResult>) -> [Any]?
    
    func executeFetchRequestWithError(_ request: NSFetchRequest<NSFetchRequestResult>) -> Error?
    
    var managedObjectModel: NSManagedObjectModel { get }
    
    var saveCtx: NSManagedObjectContext { get }
    
    var mainCtx: NSManagedObjectContext { get }
}

final class CoreDataWorker: ICoreDataWorker
{
    // MARK: - ICoreDataWorker
    
    func executeFetchRequest(_ request: NSFetchRequest<NSFetchRequestResult>) -> [Any]?
    {
        let result = try? ctx.fetch(request)
        return result
    }
    
    func executeFetchRequestWithError(_ request: NSFetchRequest<NSFetchRequestResult>) -> Error?
    {
        do
        {
            try ctx.fetch(request)
            return nil
        }
        catch
        {
            return error
        }
    }
    
    func updateOrInsert<Object: NSManagedObject>(object: Object,
                                                 completion: ((Error?) -> Void)? = nil)
    {
        performSave(completion: completion)
    }
    
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity,
                                                          completion: ((Error?) -> Void)? = nil)
    {
        entity.toManagedObject(in: ctx)
        { _ in
            self.performSave(completion: completion)
        }
    }
    
    func get<Entity: ManagedObjectConvertible>(with predicate: NSPredicate?,
                                               sortDescriptors: [NSSortDescriptor]?,
                                               fetchLimit: Int?,
                                               completion: @escaping (Result<[Entity]>) -> Void)
    {
        let fetchRequest = Entity.ManagedObject.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        if let fetchLimit = fetchLimit
        {
            fetchRequest.fetchLimit = fetchLimit
        }
        do
        {
            let results = try ctx.fetch(fetchRequest) as? [Entity.ManagedObject]
            let items: [Entity] = results?.flatMap { $0.toEntity() as? Entity } ?? []
            completion(.success(items))
        }
        catch
        {
            completion(Result.fail("\(error.localizedDescription)"))
        }
    }
    
    func injectWorker(_ coreDataWorker: inout ICoreDataWorker) { coreDataWorker = self }
    
    var managedObjectModel: NSManagedObjectModel
    {
        return storageManager.managedObjectModel
    }
    
    var saveCtx: NSManagedObjectContext { return ctx }
    
    var mainCtx: NSManagedObjectContext { return storageManager.mainContext }
    
    // MARK: - Life cycle
    
    init()
    {
        ctx = storageManager.saveContext
    }
    
    // MARK: - Private methods
    
    private func performSave(completion: ((Error?) -> Void)?)
    {
        coreDataStack.performSave(context: ctx, completion: completion)
    }
    
    // MARK: - Private properties
    
    private let coreDataStack: ICoreDataStack = CoreDataStack()
    
    private let storageManager: IStorageManager = StorageManager()
    
    private let ctx: NSManagedObjectContext
}

extension ICoreDataWorker
{
    func updateOrInsert<Object: NSManagedObject>(object: Object,
                                                 completion: ((Error?) -> Void)? = nil)
    {
        updateOrInsert(object: object, completion: completion)
    }
    
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity,
                                                          completion: ((Error?) -> Void)? = nil)
    {
        updateOrInsert(entity: entity, completion: completion)
    }
}
