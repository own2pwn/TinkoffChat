//
//  Communication.swift
//  TinkoffChat
//
//  Created by Evgeniy on 11.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

// MARK: - MPC

protocol Communicator
{
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: CommunicatorDelegate? { get set }
    var online: Bool { get set }
}

protocol CommunicatorDelegate: class
{
    // MARK: - Discovering

    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)

    // MARK: - Errors

    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    // MARK: - Messages

    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

// MARK: - Communication

struct Peer_
{
    let userID: String
    let userName: String?
    var lastMessageDate: Date?
}

struct Message
{
    let message: String
    let sentDate: Date
    let sender: String
    let receiver: String
}

enum MultipeerCommunicatorError: Error
{
    case noSessionData
    case noPeersInSession
}
