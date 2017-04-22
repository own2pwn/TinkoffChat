//
//  MPCService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IMPCService
{
    func send(message: String)
    
    weak var delegate: IMPCServiceDelegate? { get set }
}

protocol IMPCServiceDelegate: class
{
    func doJob()
}

final class MPCService: IMPCService, IMPCWorkerDelegate
{
    // MARK: - Life cycle
    
    init(with mpcWorker: IMPCWorker)
    {
        self.mpcWorker = mpcWorker
    }
    
    // MARK: - IMPCService
    
    func send(message: String)
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
    
    func failedToStartAdvertising(error: Error)
    {
        delegate?.doJob()
    }
    
    func failedToStartBrowsingForUsers(error: Error)
    {
        delegate?.doJob()
    }
    
    // MARK: - Private methods
    
    private func setupLogic()
    {
        mpcWorker.delegate = self
    }
    
    // MARK: - Private properties
    
    private let mpcWorker: IMPCWorker
}
