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
        let service = MPCService(mpcWorker: mpcWorker)
        
        return service
    }
    
    // MARK: - Private
    
    // MARK: Services
    
    // MARK: Core object
    
    private static let mpcWorker: IMPCWorker = MPCWorker()
    
    private static let coreDataWorker: ICoreDataWorker = CoreDataWorker()
    
    private static var fetchRequestProvider: IFetchRequestProvider = {
        FetchRequestProvider(coreDataWorker: coreDataWorker)
    }()
}
