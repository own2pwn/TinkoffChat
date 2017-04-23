//
//  ConversationAssembly.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class ConversationAssembly
{
    let model: IConversationModel
    let mpcService: IMPCService
    
    init(with mpcService: IMPCService)
    {
        let model = ConversationModel(mpcService: mpcService)
        
        self.mpcService = mpcService
        self.model = model
    }
}
