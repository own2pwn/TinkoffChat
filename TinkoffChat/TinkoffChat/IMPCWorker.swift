//
//  IMPCWorker.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

struct Peer
{
    let userID: String
    let userName: String?
    let isOnline: Bool
}

protocol IMPCWorker: class
{
    func send(message: String, to userID: String, completion: (Error?) -> Void)
    func peers(where state: UserState) -> [Peer]
    
    func retrieveConversations(where state: UserState, completion: ([ConversationDataModel]) -> Void)
    
    var online: Bool { get set }
    
    weak var delegate: IMPCWorkerDelegate? { get set }
}

protocol IMPCWorkerDelegate: class
{
    // MARK: Discovering
    
    func didFoundUser(userID: String, userName: String?)
    
    func didLostUser(userID: String)
    
    // MARK: Messages
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    
    // MARK: Errors
    
    func failedToStartBrowsingForUsers(error: Error)
    
    func failedToStartAdvertising(error: Error)
}
