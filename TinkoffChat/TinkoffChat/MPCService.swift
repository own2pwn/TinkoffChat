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

protocol IMPCService: class
{
    func send(message: String, to: String, completion: (Error?) -> Void)
    
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
    
    func send(message: String, to: String, completion: (Error?) -> Void)
    {
        mpcWorker.send(message: message, to: to, completion: completion)
    }
    
    var delegate: IMPCServiceDelegate?
    
    // MARK: - IMPCWorkerDelegate
    
    func didFoundUser(userID: String, userName: String?)
    {
        delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String)
    {
        delegate?.didLostUser(userID: userID)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        delegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func log(error message: String)
    {
        print("There was an error!: \(message)")
    }
    
    func failedToStartAdvertising(error: Error) { delegate?.log(error: error.localizedDescription) }
    
    func failedToStartBrowsingForUsers(error: Error) { delegate?.log(error: error.localizedDescription) }
    
    // MARK: - Private properties
    
    private let mpcWorker: IMPCWorker
}
