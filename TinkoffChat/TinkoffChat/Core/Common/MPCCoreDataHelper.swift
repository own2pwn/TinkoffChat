//
//  MPCCoreDataHelper.swift
//  TinkoffChat
//
//  Created by Evgeniy on 13.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

// swiftlint:disable force_cast

import UIKit

protocol IMPCCoreDataHelper
{
    func updateOrCreateAppUser(_ localUserId: String) -> String
    
    func didFoundUser(_ userId: String, name: String?)
    
    func createOrUpdateConversation(with participant: User)
    
    func didReceiveMessage(_ text: String, from userId: String)
    
    func didLostUser(_ userId: String)
}

final class MPCCoreDataHelper: IMPCCoreDataHelper
{
    // MARK: - IMPCCoreDataHelper
    
    func updateOrCreateAppUser(_ localUserId: String) -> String
    {
        let appUser = fetchRequestProvider.appUser()
        if let appUserModel = coreDataWorker.executeFetchRequest(appUser)?.first as? AppUser
        {
            let displayName = appUserModel.currentUser!.name
            localAppUser = appUserModel
            localUser = appUserModel.currentUser!
            
            return displayName
        }
        return createAppUser(localUserId)
    }
    
    func didFoundUser(_ userId: String, name: String?)
    {
        let userById = fetchRequestProvider.userById(userId)
        var newUser: User
        
        if let userModel = coreDataWorker.executeFetchRequest(userById)?.first as? User
        {
            userModel.isOnline = true
            userModel.name = name ?? ""
            
            newUser = userModel
        }
        else // create a new user
        {
            let userModel = User(context: coreDataWorker.saveCtx)
            userModel.isOnline = true
            userModel.name = name ?? ""
            userModel.userId = userId
            
            newUser = userModel
        }
        coreDataWorker.updateOrInsert(object: newUser)
        { error in
            if let error = error
            {
                print("^ processNewUser: \(error)")
            }
            self.createOrUpdateConversation(with: newUser)
        }
    }
    
    func createOrUpdateConversation(with participant: User)
    {
        guard let conversations = participant.conversations?.allObjects as? [Conversation],
            conversations.count > 0 else
        {
            // no conversation with user
            
            let participants = NSSet(array: [localUser, participant])
            let newConversation = Conversation(context: coreDataWorker.saveCtx)
            
            newConversation.conversationId = CommunicationHelper.generateUniqueId()
            newConversation.isOnline = participant.isOnline
            newConversation.appUser = localAppUser
            newConversation.participants = participants
            
            coreDataWorker.updateOrInsert(object: newConversation)
            { error in
                if let error = error
                {
                    print("^ createOrUpdateConversation: \(error)")
                }
            }
            return
        }
        // there is already a conversation with this participant
        
        for conversation in conversations
        {
            conversation.isOnline = participant.isOnline
        }
        coreDataWorker.updateOrInsert(object: participant)
        { error in
            if let error = error
            {
                print("^ createOrUpdateConversation: \(error)")
            }
        }
    }
    
    func didReceiveMessage(_ text: String, from userId: String)
    {
        let conversationByUserId = fetchRequestProvider.conversationByUserId(userId)
        let userById = fetchRequestProvider.userById(userId)
        
        if let conversationModel = coreDataWorker.executeFetchRequest(conversationByUserId)?.first as? Conversation,
            let senderUserModel = coreDataWorker.executeFetchRequest(userById)?.first as? User
        {
            let newMessage = Message(context: coreDataWorker.saveCtx)
            let messagesCountInConversation = conversationModel.messages?.count ?? 0
            
            newMessage.date = NSDate()
            newMessage.messageId = CommunicationHelper.generateUniqueId()
            newMessage.orderIndex = Int64(messagesCountInConversation)
            newMessage.text = text
            
            newMessage.conversation = conversationModel
            newMessage.lastMessageAppUser = localAppUser
            newMessage.lastMessageInConversation = conversationModel
            newMessage.receiver = localUser
            newMessage.sender = senderUserModel
            newMessage.undreadInConversation = conversationModel
            
            coreDataWorker.updateOrInsert(object: newMessage)
            { error in
                if let error = error
                {
                    print("^ processNewMessage: \(error)")
                }
            }
        }
    }
    
    func didLostUser(_ userId: String)
    {
        let userById = fetchRequestProvider.userById(userId)
        let userModel = coreDataWorker.executeFetchRequest(userById)?.first as! User
        userModel.isOnline = false
        
        coreDataWorker.updateOrInsert(object: userModel)
        { error in
            if let error = error
            {
                print("^ processLostUser: \(error)")
            }
            self.createOrUpdateConversation(with: userModel)
        }
    }
    
    // MARK: - Private methods
    
    private func createAppUser(_ localUserId: String) -> String
    {
        let localAppUser = AppUser(context: coreDataWorker.saveCtx)
        let localUser = User(context: coreDataWorker.saveCtx)
        let localUserName = UIDevice.current.name
        
        localUser.isOnline = true
        localUser.name = localUserName
        localUser.userId = localUserId
        
        localUser.appUser = localAppUser
        localUser.currentAppUser = localAppUser
        
        let users = NSSet(object: localUser)
        localAppUser.currentUser = localUser
        localAppUser.users = users
        
        coreDataWorker.updateOrInsert(object: localAppUser)
        coreDataWorker.updateOrInsert(object: localUser)
        
        self.localAppUser = localAppUser
        self.localUser = localUser
        
        return localUserName
    }
    
    // MARK: - Private properties
    
    // MARK: Lazy
    
    private lazy var localAppUser: AppUser = {
        let appUser = self.fetchRequestProvider.appUser()
        let appUserModel = self.coreDataWorker.executeFetchRequest(appUser)?.first as! AppUser
        
        return appUserModel
    }()
    
    private lazy var localUser: User = {
        self.localAppUser.currentUser!
    }()
    
    // MARK: Core object
    
    private let coreDataWorker = CoreDataAssembly.coreDataWorker
    
    private let fetchRequestProvider = CoreDataAssembly.fetchRequestProvider
}

// swiftlint:enable force_cast
