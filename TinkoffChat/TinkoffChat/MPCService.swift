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

protocol IMPCService
{
    func send(message: String, to: String, completion: (Error?) -> Void)
    func conversations(where peerState: UserState, completion: ([ConversationDataModel]) -> Void)
    
    weak var delegate: IMPCServiceDelegate? { get set }
}

protocol IMPCServiceDelegate: class
{
    func append(message: String, sender: String)
    func append(userID: String, userName: String?)
    func remove(userID: String)
    
    func log(error message: String)
}

final class MPCService: IMPCService, IMPCWorkerDelegate
{
    // MARK: - Life cycle
    
    init(with mpcWorker: IMPCWorker)
    {
        self.mpcWorker = mpcWorker
    }
    
    // MARK: - IMPCService
    
    func send(message: String, to: String, completion: (Error?) -> Void)
    {
        mpcWorker.send(message: message, to: to, completion: completion)
    }
    
    func conversations(where peerState: UserState, completion: ([ConversationDataModel]) -> Void)
    {
        mpcWorker.retrieveConversations(where: peerState, completion: completion)
    }
    
    var delegate: IMPCServiceDelegate?
    
    // MARK: - IMPCWorkerDelegate
    
    func didFoundUser(userID: String, userName: String?)
    {
        delegate?.append(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String)
    {
        delegate?.remove(userID: userID)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        delegate?.append(message: text, sender: fromUser)
    }
    
    func failedToStartAdvertising(error: Error) { delegate?.log(error: error.localizedDescription) }
    
    func failedToStartBrowsingForUsers(error: Error) { delegate?.log(error: error.localizedDescription) }
    
    // MARK: - Private methods
    
    private func setupLogic()
    {
        mpcWorker.delegate = self
    }
    
    // MARK: - Private properties
    
    private let mpcWorker: IMPCWorker
}
