//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

/*
 1. get url of store

 */

protocol ICoreDataStack
{
    func retrieveData()
    func save(data: Data)

}

class CoreDataStack
{
    init()
    {
        
    }

    // MARK: - Private properties

    // MARK: Lazy

    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let url = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd") else
        {
            print("Can't obtain URL for core data storage model")
            return nil
        }
        return NSManagedObjectModel(contentsOf: url)
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {

        guard let model = self.managedObjectModel else
        {
            print("Can't initialize managedObjectModel")
            return nil
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do
        {
            try coordinator
        }

        catch
        {

        }

        return coordinator
    }()

    // MARK: Stored

    private let managedObjectModelName = "tfs_chat_model"
}

/*
 1. ViewDidload - fetch, subscribe

 */
