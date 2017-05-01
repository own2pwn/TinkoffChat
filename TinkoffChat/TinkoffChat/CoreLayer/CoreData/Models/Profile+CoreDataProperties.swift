//
//  Profile+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Evgeniy on 30.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

extension Profile
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile>
    {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var aboutUser: String?
    @NSManaged public var userImage: NSData?
    @NSManaged public var userName: String?

}
