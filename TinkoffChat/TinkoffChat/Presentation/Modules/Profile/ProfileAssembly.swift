//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

class ProfileAssembly
{
    func profileModel() -> IProfileModel
    {
        return ProfileModel(coreDataService: coreDataService(),
                            dataStoreService: dataStoreService())
    }

    // MARK: - Private

    // MARK: Services

    private func coreDataService() -> ICoreDataService
    {
        return CoreDataService(coreDataWorker: coreDataWorker)
    }

    private func dataStoreService() -> IDataStoreService
    {
        return DataStoreService()
    }

    // MARK: Core objects

    private let coreDataWorker: ICoreDataWorker = CoreDataAssembly.coreDataWorker
}
