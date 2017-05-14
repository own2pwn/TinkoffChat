//
//  IManagedObject.swift
//  TinkoffChat
//
//  Created by Evgeniy on 30.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import CoreData

protocol IManagedObject
{
    associatedtype Entity
    func toEntity() -> Entity?
}

extension IManagedObject where Self: NSManagedObject
{
    static func findFirstOrInsert(in context: NSManagedObjectContext,
                                  with predicate: NSPredicate? = nil,
                                  completion: @escaping (Self) -> Void)
    {
        findFirst(in: context,
                  with: predicate,
                  sortDescriptors: nil)
        { result in
            if let result = result { completion(result) }
            else
            {
                insert(in: context, completion: { result in completion(result) })
            }
        }
    }

    private static func findFirst(in context: NSManagedObjectContext, with predicate: NSPredicate? = nil,
                                  sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping (Self?) -> Void)
    {
        fetch(from: context, with: predicate,
              sortDescriptors: sortDescriptors, fetchLimit: 1)
        { result in
            completion(result?.first)
        }
    }

    private static func insert(in context: NSManagedObjectContext,
                               completion: @escaping (Self) -> Void)
    {
        completion(Self(context: context))
    }

    private static func fetch(from context: NSManagedObjectContext, with predicate: NSPredicate?,
                              sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?,
                              completion: @escaping ([Self]?) -> Void)
    {
        let fetchRequest = Self.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false

        if let fetchLimit = fetchLimit { fetchRequest.fetchLimit = fetchLimit }

        var result: [Self]?
        context.perform
        {
            do
            {
                result = try context.fetch(fetchRequest) as? [Self]
            }
            catch
            {
                result = nil
                print("CoreData was failed to fetch fetchrequest!Error: \(error)")
            }
            completion(result)
        }
    }
}
