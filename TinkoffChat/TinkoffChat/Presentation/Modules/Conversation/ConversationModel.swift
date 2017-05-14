//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationModel
{
    func initFetchedResultsController(_ participant: User,
                                      _ delegate: NSFetchedResultsControllerDelegate)

    func messagesCount() -> Int

    func isIncomingMessage(_ orderIndex: Int) -> Bool

    func fetchMessageDisplayModel(at orderIndex: Int) -> MessageDisplayModel

    func saveMessage(_ message: String,
                     receiverId: String)
}

final class ConversationModel: IConversationModel
{
    // MARK: - IConversationModel

    func initFetchedResultsController(_ participant: User,
                                      _ delegate: NSFetchedResultsControllerDelegate)
    {
        self.participant = participant
        messageFRC = frcProviderService.messageFetchedResultsController(participant, delegate)
    }

    func messagesCount() -> Int
    {
        // swiftlint:disable force_cast
        let conversation = participant.conversations?.allObjects.first as! Conversation
        return conversation.messages!.count
    }

    func fetchMessageDisplayModel(at orderIndex: Int) -> MessageDisplayModel
    {
        let conversation = participant.conversations?.allObjects.first as! Conversation
        let message = (conversation.messages?.allObjects as! [Message])
            .filter({ $0.orderIndex == Int64(orderIndex) })
            .first!

        return MessageDisplayModel(text: message.text, date: message.date as Date)
    }

    func isIncomingMessage(_ orderIndex: Int) -> Bool
    {
        let conversation = participant.conversations?.allObjects.first as! Conversation
        let messages = (conversation.messages?.allObjects as! [Message]).sorted(by: { $0.orderIndex < $1.orderIndex })
        let message = messages[orderIndex]

        return message.sender == participant
    }

    func saveMessage(_ message: String,
                     receiverId: String)
    {
        let userById = fetchRequestProvider.userById(receiverId)
        let appUser = fetchRequestProvider.appUser()

        let receiverModel = coreDataWorker.executeFetchRequest(userById)!.first as! User
        let conversationModel = receiverModel.conversations!.allObjects.first as! Conversation
        let currentAppUser = coreDataWorker.executeFetchRequest(appUser)!.first as! AppUser
        // swiftlint:enable force_cast
        let currentUser = currentAppUser.currentUser!

        let newMessage = Message(context: coreDataWorker.saveCtx)
        let messagesCountInConversation = conversationModel.messages?.count ?? 0

        newMessage.date = NSDate()
        newMessage.messageId = CommunicationHelper.generateUniqueId()
        newMessage.orderIndex = Int64(messagesCountInConversation)
        newMessage.text = message

        newMessage.conversation = conversationModel
        newMessage.lastMessageAppUser = currentAppUser
        newMessage.lastMessageInConversation = conversationModel
        newMessage.receiver = receiverModel
        newMessage.sender = currentUser
        newMessage.undreadInConversation = conversationModel

        coreDataWorker.updateOrInsert(object: newMessage)
        { error in
            if let error = error
            {
                print("^ saveMessage: \(error)")
            }
        }
    }

    // MARK: - Life cycle

    init(mpcService: IMPCService,
         coreDataWorker: ICoreDataWorker,
         frcProviderService: IFetchedResultsControllerProviderService)
    {
        self.mpcService = mpcService
        self.coreDataWorker = coreDataWorker
        self.frcProviderService = frcProviderService

        fetchRequestProvider = FetchRequestProvider(coreDataWorker: coreDataWorker)
    }

    // MARK: - Private properties

    private var participant: User!

    private var messageFRC: NSFetchedResultsController<Message>!

    // MARK: Services

    private let mpcService: IMPCService

    private let frcProviderService: IFetchedResultsControllerProviderService

    // MARK: Core objects

    private let coreDataWorker: ICoreDataWorker

    private let fetchRequestProvider: IFetchRequestProvider
}
