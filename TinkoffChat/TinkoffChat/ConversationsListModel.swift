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
    func loadConversations(for section: ConversationsListTableViewSections) // TODO: rename?
}

protocol IConversationsListModelDelegate: IBaseModelDelegate
{
    func updateView(with data: [ConversationsListCellDisplayModel])
}

class ConversationsListModel: IConversationsListModel
{
    weak var delegate: IConversationsListModelDelegate?
    
    let coreDataService: ICoreDataService
    
    init(coreDataService: ICoreDataService)
    {
        self.coreDataService = coreDataService
    }
    
    func loadConversations(for section: ConversationsListTableViewSections)
    {
        coreDataService.retrieveData
            { error, data in
                
                // TODO: check if section == 2 then load for all, else for requested one
                
                if let error = error
                {
                    delegate?.show(error: error.localizedDescription)
                }
                else // if let conversations = data as? [conversations]
                {
                    // let conversations = data.map({ConversationsListCellDisplayModel(userName: <#T##String?#>, message: <#T##String?#>, messageDate: <#T##Date?#>)})
                    // TODO: parse conversations
                    delegate?.updateView(with: data as! [ConversationsListCellDisplayModel])
                }
        }
    }
}
