//
//  ConversationsListAssembly.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class ConversationsListAssembly
{
    let model: IConversationsListModel
    let mpcService: IMPCService

    init()
    {
        let mpcAssembly = MPCAssembly()
        mpcService = mpcAssembly.mpcService()
        
        let model = ConversationsListModel(mpcService: mpcService)
        mpcService.delegate = model
        self.model = model
    }
}
