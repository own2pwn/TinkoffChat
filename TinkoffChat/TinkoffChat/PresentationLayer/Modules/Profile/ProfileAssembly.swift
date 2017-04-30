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
        return ProfileModel(gcdService: gcdService(),
                            operationDataStoreService: operationDataStoreService())
    }

    // MARK: - Private methods

    // MARK: - Services

    private func gcdService() -> IDataStore
    {
        return GCDService(dataStore: dataStore)
    }

    func operationDataStoreService() -> IDataStore
    {
        return OperationDataStoreService(dataStore: dataStore)
    }

    // MARK: - Private properties

    private let dataStore = DataStore()
}
