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
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity, timeOut: Double?,
                                                          completion: @escaping (Error?) -> Void)
}

class CoreDataWorker: ICoreDataWorker
{
    func updateOrInsert<Entity: ManagedObjectConvertible>(entity: Entity, timeOut: Double?,
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
