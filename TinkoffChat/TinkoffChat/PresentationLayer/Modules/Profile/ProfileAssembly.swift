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
    lazy var model: IProfileModel = {
        ProfileModel(gcdService: self.gcdService(), operationDataStoreService: self.operationDataStoreService())
    }()

    func gcdService() -> IDataStore
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
