//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

typealias ConversationDataSourceType = (userID: String, model: ConversationsListCellDisplayModel)
typealias ConversationMessageType = (userID: String, messages: [Message])

struct ConversationsListCellDisplayModel
{
    let userName: String?
    var messages: [Message]
}

class Message
{
    let message: String
    let sentDate = Date()
    let sender: String
    let receiver: String

    init(message: String, sender: String, receiver: String)
    {
        self.message = message
        self.sender = sender
        self.receiver = receiver
    }
}

protocol IConversationsListModel: class
{
    weak var delegate: IConversationsListModelDelegate? { get set }
    func loadConversations(for section: ConversationsListTableViewSections, completion: ([ConversationDataModel]) -> Void)
}

protocol IConversationsListModelDelegate: class
{
    func updateView(with data: [ConversationDataSourceType])
    func updateMessages(with data: [ConversationMessageType])
}

final class ConversationsListModel: IConversationsListModel, IMPCServiceDelegate
{
    // MARK: - IConversationsListModel

    weak var delegate: IConversationsListModelDelegate?

    init(mpcService: IMPCService)
    {
        self.mpcService = mpcService
    }

    func loadConversations(for section: ConversationsListTableViewSections, completion: ([ConversationDataModel]) -> Void)
    {
        // TODO: completion

        switch section {
        case .offlineUsers:
            break
        case .onlineUsers:
            mpcService.conversations(where: .online, completion: completion)
            break
        case .all:
            break

        }
    }

    // MARK: - IMPCServiceDelegate

    func didFoundUser(userID: String, userName: String?)
    {
        let newUser = ConversationsListCellDisplayModel(userName: userName, messages: [Message]()) // ConversationsListCellDisplayModel(message: nil, messageDate: nil, userName: userName)
        let newElement = ConversationDataSourceType(userID: userID, model: newUser)

        if !isUserExists(userID: userID)
        {
            dataSource.insert(newElement, at: 0)
            delegate?.updateView(with: dataSource)
        }
    }

    func didLostUser(userID: String)
    {
        removeUser(userID: userID)
        delegate?.updateView(with: dataSource)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        let message = Message(message: text, sender: fromUser, receiver: toUser)
        appendMessage(to: fromUser, message: message)

        delegate?.updateView(with: dataSource)
    }

    func log(error message: String)
    {
        print("There was an error!: \(message)")
    }

    // MARK: - Private methods

    private func removeUser(userID: String)
    {
        for it in 0..<dataSource.count
        {
            if dataSource[it].userID == userID
            {
                dataSource.remove(at: it)
                return
            }
        }
    }

    private func appendMessage(to userID: String, message: Message)
    {
        for it in 0..<dataSource.count
        {
            if dataSource[it].userID == userID
            {
                dataSource[it].model.messages.append(message)
                print(dataSource[it].model.messages.count)
                return
            }
        }
    }

    private func isUserExists(userID: String) -> Bool
    {
        for it in 0..<dataSource.count
        {
            if dataSource[it].userID == userID
            {
                return true
            }
        }
        return false
    }

    // MARK: - Private properties

    private var dataSource = [ConversationDataSourceType]()

    private var messages = [ConversationMessageType]()

    private let mpcService: IMPCService
}
