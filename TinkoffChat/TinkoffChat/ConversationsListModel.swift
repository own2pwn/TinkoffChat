//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

struct ConversationsListCellDisplayModel: IBaseConversationCellDisplayModel
{
    var message: String?
    var messageDate: Date?
    let userName: String?
}

protocol IConversationsListModel: class
{
    weak var delegate: IConversationsListModelDelegate? { get set }
    func loadConversations(for section: ConversationsListTableViewSections, completion: ([ConversationDataModel]) -> Void)
}

protocol IConversationsListModelDelegate: IBaseModelDelegate
{
    func updateView(with data: [ConversationsListCellDisplayModel])
}

final class ConversationsListModel: IConversationsListModel
{
    weak var delegate: IConversationsListModelDelegate?

    init(mpcService: IMPCService)
    {
        self.mpcService = mpcService
    }

    func loadConversations(for section: ConversationsListTableViewSections, completion: ([ConversationDataModel]) -> Void)
    {
        // TODO: completion

        switch section {
        case .offlineUsers:
            break
        case .onlineUsers:
            mpcService.conversations(where: .online, completion: completion)
            break
        case .all:
            break

        }
    }

    private let mpcService: IMPCService
}
