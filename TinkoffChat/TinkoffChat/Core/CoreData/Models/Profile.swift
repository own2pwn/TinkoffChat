//
//  Profile+CoreDataClass.swift
//  TinkoffChat
//
//  Created by Evgeniy on 30.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject {}

struct ProfileEntityModel
{
    let aboutUser: String?
    let imagePath: String?
    let userName: String?
}

extension ProfileEntityModel: ManagedObjectConvertible
{
    typealias ManagedObject = Profile

    func toManagedObject(in context: NSManagedObjectContext,
                         completion: @escaping (Profile) -> Void)
    {
        Profile.findFirstOrInsert(in: context)
        { profileMO in
            profileMO.aboutUser = self.aboutUser
            profileMO.imagePath = self.imagePath
            profileMO.userName = self.userName

            completion(profileMO)
        }
    }
}

extension ProfileEntityModel: ModelValidable
{
    typealias Entity = ProfileEntityModel

    func validate() -> ProfileEntityModel?
    {
        guard aboutUser != nil || imagePath != nil || userName != nil else { return nil }

        return ProfileEntityModel(aboutUser: aboutUser,
                                  imagePath: imagePath,
                                  userName: userName)
    }
}

extension Profile: IManagedObject
{
    typealias Entity = ProfileEntityModel

    func toEntity() -> ProfileEntityModel?
    {
        return ProfileEntityModel(aboutUser: aboutUser,
                                  imagePath: imagePath,
                                  userName: userName)
    }
}
