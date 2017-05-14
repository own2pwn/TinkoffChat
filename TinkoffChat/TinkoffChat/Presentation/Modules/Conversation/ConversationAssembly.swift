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
    var model: IConversationModel!
    var mpcService: IMPCService!

    // MARK: - Life cycle

    init(with mpcService: IMPCService)
    {
        let model = ConversationModel(mpcService: mpcService,
                                      coreDataWorker: coreDataWorker,
                                      frcProviderService: frcProviderService)
        self.mpcService = mpcService
        self.model = model
    }

    // MARK: - Private

    // MARK: Services

    private let frcProviderService: IFetchedResultsControllerProviderService = FetchedResultsControllerProviderService()

    // MARK: Core object

    private let coreDataWorker: ICoreDataWorker = CoreDataAssembly.coreDataWorker

    private let fetchRequestProvider: IFetchRequestProvider = CoreDataAssembly.fetchRequestProvider
}
