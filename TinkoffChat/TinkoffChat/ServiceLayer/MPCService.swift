//
//  MPCService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

enum UserState: Int
{
    case offline = 0
    case online
}

final class Message
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

protocol IMPCService: class
{
    func getDataSource(completion: ([ConversationDataSourceType]) -> Void)
    func loadMessages(for userID: String, with user: String, completion: ([Message]) -> Void)
    func send(message: String, to: String, completion: (Error?) -> Void)
    func localUserID() -> String

    weak var delegate: IMPCServiceDelegate? { get set }
}

protocol IMPCServiceDelegate: class
{
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)

    func log(error message: String)
}

final class MPCService: IMPCService, IMPCServiceDelegate
{
    // MARK: - Life cycle

    init(with mpcWorker: IMPCWorker)
    {
        self.mpcWorker = mpcWorker
    }

    // MARK: - IMPCService

    func getDataSource(completion: ([ConversationDataSourceType]) -> Void)
    {
        completion(dataSource)
    }

    func loadMessages(for userID: String, with user: String, completion: ([Message]) -> Void)
    {
        var relatedMessages = [Message]()

        for e in dataSource
        {
            for m in e.model.messages
            {
                if m.sender == userID && m.receiver == user || m.sender == user && m.receiver == userID
                {
                    relatedMessages.append(m)
                }
            }
        }
        completion(relatedMessages)
    }

    func send(message: String, to: String, completion: (Error?) -> Void)
    {
        //        mpcWorker.send(message: message, to: to, completion: completion)
        mpcWorker.send(message: message, to: to)
        { error in
            if error == nil
            {
                let newMessage = Message(message: message, sender: localUserID(), receiver: to)
                appendMessage(to: to, message: newMessage)

            }
            completion(error)
        }
    }

    func localUserID() -> String
    {
        return mpcWorker.getLocalUserID()
    }

    weak var delegate: IMPCServiceDelegate?

    // MARK: - IMPCWorkerDelegate

    func didFoundUser(userID: String, userName: String?)
    {
        let newUser = ConversationsListCellDisplayModel(userName: userName, messages: [Message]())
        let newElement = ConversationDataSourceType(userID: userID, model: newUser)

        if !isUserExists(userID: userID)
        {
            dataSource.insert(newElement, at: 0)
        }
        delegate?.didFoundUser(userID: userID, userName: userName)
    }

    func didLostUser(userID: String)
    {
        removeUser(userID: userID)
        delegate?.didLostUser(userID: userID)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        let message = Message(message: text, sender: fromUser, receiver: toUser)
        appendMessage(to: fromUser, message: message)
        delegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }

    func log(error message: String)
    {
        print("There was an error!: \(message)")
    }

    func failedToStartAdvertising(error: Error) { delegate?.log(error: error.localizedDescription) }

    func failedToStartBrowsingForUsers(error: Error) { delegate?.log(error: error.localizedDescription) }

    // MARK: - Private methods

    private func removeUser(userID: String)
    {
        for it in 0..<dataSource.count where dataSource[it].userID == userID
        {
            dataSource.remove(at: it)
            return
        }
    }

    private func sortUsers(completion: @escaping () -> Void)
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.dataSource.sort(by: self.displayModelSorter)
            completion()
        }
    }

    private func displayModelSorter(_ lv: ConversationDataSourceType, _ rv: ConversationDataSourceType) -> Bool
    {
        let d1 = lv.model.messages.last?.sentDate ?? Date(timeIntervalSince1970: 0)
        let d2 = rv.model.messages.last?.sentDate ?? Date(timeIntervalSince1970: 0)

        let n1 = lv.model.userName?.lowercased() ?? "Z"
        let n2 = rv.model.userName?.lowercased() ?? "Z"

        if d1 == d2
        {
            return n1 < n2
        }
        return d1 > d2
    }

    private func appendMessage(to userID: String, message: Message)
    {
        for it in 0..<dataSource.count where dataSource[it].userID == userID
        {
            dataSource[it].model.messages.append(message)
            return
        }
    }

    private func isUserExists(userID: String) -> Bool
    {
        for it in 0..<dataSource.count where dataSource[it].userID == userID
        {
            return true
        }
        return false
    }

    // MARK: - Private properties

    private let mpcWorker: IMPCWorker

    private var dataSource = [ConversationDataSourceType]()
}
