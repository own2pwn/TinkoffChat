//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

struct ConversationsListCellDisplayModel: IBaseConversationCellDisplayModel
{
    var message: String?
    var messageDate: Date?
    let userName: String?
}

struct Message
{
    let message: String
    let sentDate = Date()
    let sender: String
    let receiver: String
}

protocol IConversationsListModel: class
{
    weak var delegate: IConversationsListModelDelegate? { get set }
    func loadConversations(for section: ConversationsListTableViewSections, completion: ([ConversationDataModel]) -> Void)
}

protocol IConversationsListModelDelegate: class
{
    func updateView(with data: [String: ConversationsListCellDisplayModel])
    func updateMessages(with data: [String: [Message]])
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
        let newUser = ConversationsListCellDisplayModel(message: nil, messageDate: nil, userName: userName)
        dataSource[userID] = newUser
        delegate?.updateView(with: dataSource)
    }

    func didLostUser(userID: String)
    {
        dataSource.removeValue(forKey: userID)
        delegate?.updateView(with: dataSource)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        let message = Message(message: text, sender: fromUser, receiver: toUser)
        var newMessages = [Message]()

        if let oldMessages = messages[fromUser]
        {
            newMessages = oldMessages
            newMessages.append(message)
        }
        else
        {
            newMessages = [message]
        }

        messages[fromUser] = newMessages
        delegate?.updateMessages(with: messages)
    }

    func log(error message: String)
    {
        print("There was an error!: \(message)")
    }

    // MARK: - Private properties

    private var dataSource = [String: ConversationsListCellDisplayModel]()

    private var messages = [String: [Message]]()

    private let mpcService: IMPCService
}
