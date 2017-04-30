//
//  ManagedObjectConvertible.swift
//  TinkoffChat
//
//  Created by Evgeniy on 30.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import CoreData

protocol ManagedObjectConvertible
{
    associatedtype ManagedObject: NSManagedObject, IManagedObject
    func toManagedObject(in context: NSManagedObjectContext,
                         completion: @escaping (ManagedObject) -> Void)
}
