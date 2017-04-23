//
//  DataStoreService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class GCDService: IDataStore
{
    // MARK: - IDataStore

    func saveProfileData(_ profile: ProfileDisplayModel, completion: @escaping (Bool, Error?) -> Void)
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.dataStore.saveProfileData(profile, completion: { bSuccess, err in
                DispatchQueue.main.async
                {
                    completion(bSuccess, err)
                }
            })
        }
    }

    func loadProfileData(completion: @escaping (ProfileDisplayModel, Error?) -> Void)
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.dataStore.loadProfileData(completion: { profile, err in
                DispatchQueue.main.async
                {
                    completion(profile, err)
                }
            })
        }
    }

    // MARK: - Life cycle

    init(dataStore: IDataStore)
    {
        self.dataStore = dataStore
    }

    // MARK: - Private properties

    private let dataStore: IDataStore
}
