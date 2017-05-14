//
//  User+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Evgeniy on 08.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

extension User
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User>
    {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var isOnline: Bool
    @NSManaged public var name: String
    @NSManaged public var userId: String
    @NSManaged public var appUser: AppUser?
    @NSManaged public var conversations: NSSet?
    @NSManaged public var currentAppUser: AppUser?
    @NSManaged public var incomingMessages: NSSet?
    @NSManaged public var outgoingMessages: NSSet?
    @NSManaged public var typingInConversations: NSSet?

}

// MARK: Generated accessors for conversations
extension User
{
    @objc(addConversationsObject:)
    @NSManaged public func addToConversations(_ value: Conversation)

    @objc(removeConversationsObject:)
    @NSManaged public func removeFromConversations(_ value: Conversation)

    @objc(addConversations:)
    @NSManaged public func addToConversations(_ values: NSSet)

    @objc(removeConversations:)
    @NSManaged public func removeFromConversations(_ values: NSSet)

}

// MARK: Generated accessors for incomingMessages
extension User
{
    @objc(addIncomingMessagesObject:)
    @NSManaged public func addToIncomingMessages(_ value: Message)

    @objc(removeIncomingMessagesObject:)
    @NSManaged public func removeFromIncomingMessages(_ value: Message)

    @objc(addIncomingMessages:)
    @NSManaged public func addToIncomingMessages(_ values: NSSet)

    @objc(removeIncomingMessages:)
    @NSManaged public func removeFromIncomingMessages(_ values: NSSet)

}

// MARK: Generated accessors for outgoingMessages
extension User
{
    @objc(addOutgoingMessagesObject:)
    @NSManaged public func addToOutgoingMessages(_ value: Message)

    @objc(removeOutgoingMessagesObject:)
    @NSManaged public func removeFromOutgoingMessages(_ value: Message)

    @objc(addOutgoingMessages:)
    @NSManaged public func addToOutgoingMessages(_ values: NSSet)

    @objc(removeOutgoingMessages:)
    @NSManaged public func removeFromOutgoingMessages(_ values: NSSet)

}

// MARK: Generated accessors for typingInConversations
extension User
{
    @objc(addTypingInConversationsObject:)
    @NSManaged public func addToTypingInConversations(_ value: Conversation)

    @objc(removeTypingInConversationsObject:)
    @NSManaged public func removeFromTypingInConversations(_ value: Conversation)

    @objc(addTypingInConversations:)
    @NSManaged public func addToTypingInConversations(_ values: NSSet)

    @objc(removeTypingInConversations:)
    @NSManaged public func removeFromTypingInConversations(_ values: NSSet)

}
