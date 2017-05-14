//
//  Message+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Evgeniy on 08.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

extension Message
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message>
    {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate
    @NSManaged public var messageId: String
    @NSManaged public var orderIndex: Int64
    @NSManaged public var text: String
    @NSManaged public var conversation: Conversation
    @NSManaged public var lastMessageAppUser: AppUser?
    @NSManaged public var lastMessageInConversation: Conversation?
    @NSManaged public var receiver: User
    @NSManaged public var sender: User
    @NSManaged public var undreadInConversation: Conversation?

}
