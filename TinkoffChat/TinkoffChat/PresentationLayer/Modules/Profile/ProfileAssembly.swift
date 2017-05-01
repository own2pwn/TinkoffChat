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
        return ProfileModel(coreDataWorker: coreDataWorkerService())
    }

    // MARK: - Private methods

    // MARK: - Services

    private func coreDataWorkerService() -> ICoreDataWorker
    {
        return CoreDataWorker(coreDataStack: coreDataStack,
                              storageManager: storageManager)
    }

    // MARK: - Private properties

    private let coreDataStack = CoreDataStack()

    private let storageManager = StorageManager()
}
