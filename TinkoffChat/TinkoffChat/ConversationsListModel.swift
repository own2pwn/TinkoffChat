//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

typealias ConversationDataSourceType = (userID: String, model: ConversationsListCellDisplayModel)

struct ConversationsListCellDisplayModel
{
    let userName: String?
    var messages: [Message]
}

protocol IConversationsListModel: class
{
    weak var delegate: IBaseConversationModelDelegate? { get set }
}

final class ConversationsListModel: IConversationsListModel, IMPCServiceDelegate
{
    // MARK: - IConversationsListModel

    weak var delegate: IBaseConversationModelDelegate?

    init(mpcService: IMPCService)
    {
        self.mpcService = mpcService
    }

    // MARK: - IMPCServiceDelegate

    func didFoundUser(userID: String, userName: String?)
    {
        mpcService.getDataSource
        { dataSource in
            sortDataSource(data: dataSource, completion: { sorted in
                self.delegate?.updateView(with: sorted)
            })
        }
    }

    func didLostUser(userID: String)
    {
        mpcService.getDataSource
        { dataSource in
            sortDataSource(data: dataSource, completion: { sorted in
                self.delegate?.updateView(with: sorted)
            })
        }
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    {
        mpcService.getDataSource
        { dataSource in
            sortDataSource(data: dataSource, completion: { sorted in
                self.delegate?.updateView(with: sorted)
            })
        }
    }

    func log(error message: String)
    {
        print("There was an error!: \(message)")
    }

    // MARK: - Private methods

    private func sortDataSource(data: [ConversationDataSourceType], completion: @escaping ([ConversationDataSourceType]) -> Void)
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            let sorted = data.sorted(by: self.displayModelSorter)
            completion(sorted)
        }
    }

    private func displayModelSorter(_ lv: ConversationDataSourceType, _ rv: ConversationDataSourceType) -> Bool
    {
        let d1 = lv.model.messages.last?.sentDate ?? Date(timeIntervalSince1970: 0)
        let d2 = rv.model.messages.last?.sentDate ?? Date(timeIntervalSince1970: 0)

        let n1 = lv.model.userName?.lowercased() ?? "Z"
        let n2 = rv.model.userName?.lowercased() ?? "Z"

        if d1 == d2
        {
            return n1 < n2
        }
        return d1 > d2
    }

    // MARK: - Private properties

    private let mpcService: IMPCService
}
