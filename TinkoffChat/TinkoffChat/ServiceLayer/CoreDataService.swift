//
//  CoreDataService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 08.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import CoreData

protocol ICoreDataService
{
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity,
                                                          completion: @escaping (Error?) -> Void)
    
    func get<Entity: ManagedObjectConvertible>(predicate: NSPredicate?,
                                               sortDescriptors: [NSSortDescriptor]?,
                                               fetchLimit: Int?,
                                               completion: @escaping (Result<[Entity]>) -> Void)
}

class CoreDataService: ICoreDataService
{
    // MARK: - ICoreDataService
    
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity,
                                                          completion: @escaping (Error?) -> Void)
    {
        coreDataWorker.updateOrInsert(entity: entity, completion: completion)
    }
    
    func get<Entity: ManagedObjectConvertible>(predicate: NSPredicate? = nil,
                                               sortDescriptors: [NSSortDescriptor]? = nil,
                                               fetchLimit: Int? = nil,
                                               completion: @escaping (Result<[Entity]>) -> Void)
    {
        coreDataWorker.get(with: predicate,
                           sortDescriptors: sortDescriptors,
                           fetchLimit: fetchLimit,
                           completion: completion)
    }
    
    // MARK: - Life cycle
    
    init(coreDataWorker: ICoreDataWorker)
    {
        self.coreDataWorker = coreDataWorker
    }
    
    // MARK: - Private properties
    
    private let coreDataWorker: ICoreDataWorker
}

extension ICoreDataService
{
    func get<Entity: ManagedObjectConvertible>(predicate: NSPredicate? = nil,
                                               sortDescriptors: [NSSortDescriptor]? = nil,
                                               fetchLimit: Int? = nil,
                                               completion: @escaping (Result<[Entity]>) -> Void)
    {
        get(predicate: predicate,
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            completion: completion)
    }
}
