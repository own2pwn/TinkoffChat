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
    var model: IConversationsListModel!
    let mpcService: IMPCService

    // MARK: - Life cycle

    init()
    {
        mpcService = MPCAssembly.mpcService()

        let model = ConversationsListModel(mpcService: mpcService,
                                           frcProviderService: frcProviderService)
        self.model = model
    }

    // MARK: - Private

    // MARK: Services

    private let frcProviderService: IFetchedResultsControllerProviderService = FetchedResultsControllerProviderService()

    // MARK: Core object

    internal var coreDataWorker: ICoreDataWorker!

    internal var fetchRequestProvider: IFetchRequestProvider!
}
