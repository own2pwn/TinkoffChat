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
    func loadConversations(for section: ConversationsListTableViewSections)
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

    func loadConversations(for section: ConversationsListTableViewSections)
    {
        // TODO: completion
    }

    private let mpcService: IMPCService
}
