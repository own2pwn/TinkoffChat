//
//  MPCService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IMPCService: class
{
    func send(message: String, to: String, completion: (Error?) -> Void)
}

final class MPCService: IMPCService
{
    // MARK: - IMPCService

    func send(message: String, to: String, completion: (Error?) -> Void)
    {
        mpcWorker.send(message: message, to: to, completion: completion)
    }

    // MARK: - Life cycle

    init(mpcWorker: IMPCWorker)
    {
        self.mpcWorker = mpcWorker
    }

    // MARK: - Private properties

    // MARK: Core objects

    private let mpcWorker: IMPCWorker
}
