//
//  IConversation.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IConversationModel
{
    func conversations(related toUser: String)

    func conversations(where state: UserState)
}

protocol IConversationDataModel
{
    var users: [String] { get set }
    var messages: [IMessageModel] { get set }
}

final class ConversationModel: IConversationModel
{
    // MARK: - IConversationModel

    func conversations(related toUser: String)
    {
    }

    func conversations(where state: UserState)
    {
        switch state {
        case .offline:
            mpcService.
            break
        case .online:
            break
        }
    }

    // MARK: - Life cycle

    init(mpcService: IMPCService)
    {
        self.mpcService = mpcService
    }

    private let mpcService: IMPCService
}
