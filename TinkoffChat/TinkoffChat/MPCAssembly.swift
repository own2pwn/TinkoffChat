//
//  MPCAssembly.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

class MPCAssembly
{
    static func mpcService() -> IMPCService
    {
        let service = MPCService(with: mpcWorker())

        return service
    }

    private static func mpcWorker() -> IMPCWorker
    {
        return MPCWorker()
    }
}
