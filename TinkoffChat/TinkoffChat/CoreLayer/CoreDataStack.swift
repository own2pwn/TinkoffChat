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
    func retrieveData()
    func save(data: Data)
}

class CoreDataStack {}
