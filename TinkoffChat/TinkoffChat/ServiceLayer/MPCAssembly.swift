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
    // MARK: - Services
    
    static func mpcService() -> IMPCService
    {
        return MPCService(mpcWorker: mpcWorker)
    }
    
    // MARK: - Private
    
    // MARK: Core object
    
    private static let mpcWorker: IMPCWorker = MPCWorker()
}
