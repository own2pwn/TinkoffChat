//
//  Message+CoreDataClass.swift
//  TinkoffChat
//
//  Created by Evgeniy on 08.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {}

struct MessageEntityModel
{
    let date: NSDate
    let messageId: String
    let orderIndex: Int64
    let text: String
    let conversation: Conversation?
    let lastMessageAppUser: AppUser?
    let lastMessageInConversation: Conversation?
    let receiver: User?
    let sender: User?
    let undreadInConversation: Conversation?
}

struct MessageDisplayModel
{
    let text: String
    let date: Date
}
