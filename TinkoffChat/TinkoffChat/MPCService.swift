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
    func conversations(where peerState: UserState)
    
    weak var delegate: IMPCServiceDelegate? { get set }
}

protocol IMPCServiceDelegate: class
{
    func doJob()
    func show(error message: String)
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
    
    func conversations(where peerState: UserState)
    {
        
    }
    
    var delegate: IMPCServiceDelegate?
    
    // MARK: - IMPCWorkerDelegate
    
    func didFoundUser(userID: String, userName: String?)
    {
        delegate?.doJob()
    }
    
    func didLostUser(userID: String)
    {
        delegate?.doJob()
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        delegate?.doJob()
    }
    
    func failedToStartAdvertising(error: Error) { delegate?.show(error: error.localizedDescription) }
    
    func failedToStartBrowsingForUsers(error: Error) { delegate?.show(error: error.localizedDescription) }
    
    // MARK: - Private methods
    
    private func setupLogic()
    {
        mpcWorker.delegate = self
    }
    
    // MARK: - Private properties
    
    private let mpcWorker: IMPCWorker
}
