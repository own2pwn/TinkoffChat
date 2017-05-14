//
//  User+CoreDataClass.swift
//  TinkoffChat
//
//  Created by Evgeniy on 08.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {}

struct UserEntityModel
{
    let isOnline: Bool
    let name: String
    let userId: String
}

struct UserDisplayModel
{
    let name: String
    let isOnline: Bool
    let lastMessageText: String?
    let lastMessageDate: Date?
}

extension UserEntityModel: ManagedObjectConvertible
{
    typealias ManagedObject = User

    func toManagedObject(in context: NSManagedObjectContext,
                         completion: @escaping (User) -> Void)
    {
        let predicate = NSPredicate(format: "userId == %@", userId)
        User.findFirstOrInsert(in: context, with: predicate)
        { user in
            user.isOnline = self.isOnline
            user.name = self.name
            user.userId = self.userId

            completion(user)
        }
    }
}

extension User: IManagedObject
{
    typealias Entity = UserEntityModel

    func toEntity() -> UserEntityModel?
    {
        return UserEntityModel(isOnline: isOnline,
                               name: name,
                               userId: userId)
    }
}
