//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Evgeniy on 11.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

class CommunicationManager: NSObject, CommunicatorDelegate
{
    // MARK: Discovering
    
    func didFoundUser(userID: String, userName: String?)
    {
        let info = [KDiscoveryInfo.UserID: userID, KDiscoveryInfo.UserName: userName]
        NotificationCenter.default.post(name: .DidFoundUser, object: nil, userInfo: info)
    }
    
    func didLostUser(userID: String)
    {
        let info = [KDiscoveryInfo.UserID: userID]
        NotificationCenter.default.post(name: .DidLostUser, object: nil, userInfo: info)
    }
    
    // MARK: Messages
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        let info = [KMessageInfo.Text: text, KMessageInfo.FromUser: fromUser, KMessageInfo.ToUser: toUser]
        NotificationCenter.default.post(name: .DidReceiveMessage, object: nil, userInfo: info)
    }
    
    // MARK: Errors
    
    func failedToStartBrowsingForUsers(error: Error)
    {
        print("There was an error while starting browsing for users!\nError: \(error)")
    }
    
    func failedToStartAdvertising(error: Error)
    {
        print("There was an error while starting advertising!\nError: \(error)")
    }
}
