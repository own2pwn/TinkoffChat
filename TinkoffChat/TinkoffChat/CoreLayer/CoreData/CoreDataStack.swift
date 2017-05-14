//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataStack
{
    func performSave(context: NSManagedObjectContext,
                     completion: ((Error?) -> Void)?)
}

class CoreDataStack: ICoreDataStack
{
    func performSave(context: NSManagedObjectContext,
                     completion: ((Error?) -> Void)? = nil)
    {
        guard context.hasChanges else
        {
            completion?(nil)
            return
        }
        context.perform
        { [weak self] in
            do
            {
                try context.save()
            }
            catch
            {
                print("Context hasn't saved data! Error: \(error)")
                completion?(error)
            }
            if let parent = context.parent
            {
                self?.performSave(context: parent, completion: completion)
            }
            else
            {
                completion?(nil)
            }
        }
    }
}

extension ICoreDataStack
{
    func performSave(context: NSManagedObjectContext,
                     completion: ((Error?) -> Void)? = nil)
    {
        performSave(context: context, completion: completion)
    }
}
