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
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity,
                                                          completion: @escaping (Error?) -> Void)
    
    func get<Entity: ManagedObjectConvertible>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?,
                                               fetchLimit: Int?, completion: @escaping (Result<[Entity]>) -> Void)
}

class CoreDataWorker: ICoreDataWorker
{
    // MARK: - ICoreDataWorker
    
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity,
                                                          completion: @escaping (Error?) -> Void)
    {
        entity.toManagedObject(in: ctx)
        { MO in
            self.coreDataStack.performSave(context: self.ctx)
            { error in
                completion(error)
            }
        }
    }
    
    func get<Entity: ManagedObjectConvertible>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?,
                                               fetchLimit: Int?, completion: @escaping (Result<[Entity]>) -> Void)
    {
        do
        {
            let fetchRequest = Entity.ManagedObject.fetchRequest()
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            if let fetchLimit = fetchLimit
            {
                fetchRequest.fetchLimit = fetchLimit
            }
            let results = try ctx.fetch(fetchRequest) as? [Entity.ManagedObject]
            let items: [Entity] = results?.flatMap { $0.toEntity() as? Entity } ?? []
            completion(.success(items))
        }
        catch
        {
            completion(Result.fail("Can't fetch!"))
        }
    }
    
    // MARK: - Life cycle
    
    init(coreDataStack: ICoreDataStack, storageManager: IStorageManager)
    {
        self.coreDataStack = coreDataStack
        self.storageManager = storageManager
        ctx = storageManager.masterContext
    }
    
    // MARK: - Private properties
    
    private let coreDataStack: ICoreDataStack
    
    private let storageManager: IStorageManager
    
    private let ctx: NSManagedObjectContext
}
