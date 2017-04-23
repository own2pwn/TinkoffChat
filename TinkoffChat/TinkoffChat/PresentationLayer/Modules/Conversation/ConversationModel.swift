//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol MessageCellModel: class
{
    var messageText: String? { get set }
}

protocol IConversationModel
{
    func getMessages(for userID: String, with user: String, completion: ([Message]) -> Void)

    weak var delegate: IConversationModelDelegate? { get set }
    var localUser: String { get set }
}

protocol IConversationModelDelegate: class
{
    func didLostUser(userID: String)
    func didReceiveMessage(from userID: String, message: String)
}

final class ConversationModel: IConversationModel, IMPCServiceDelegate
{
    // MARK: - IConversationModel

    func getMessages(for userID: String, with user: String, completion: ([Message]) -> Void)
    {
        mpcService.loadMessages(for: userID, with: user, completion: { messages in
            let sorted = messages.sorted(by: { (lv, rv) -> Bool in
                lv.sentDate > rv.sentDate
            })
            completion(sorted)
        })
    }

    // MARK: - IMPCServiceDelegate

    func didFoundUser(userID: String, userName: String?) {}

    func didLostUser(userID: String)
    {
        delegate?.didLostUser(userID: userID)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        if toUser == localUser
        {
            delegate?.didReceiveMessage(from: fromUser, message: text)
        }
    }

    func log(error message: String)
    {
        print(message)
    }

    weak var delegate: IConversationModelDelegate?

    lazy var localUser: String = {
        self.mpcService.localUserID()
    }()

    // MARK: - Life cycle

    init(mpcService: IMPCService)
    {
        self.mpcService = mpcService
    }

    // MARK: - Private properties

    private let mpcService: IMPCService
}
