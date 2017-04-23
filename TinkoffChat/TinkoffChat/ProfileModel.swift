//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IProfileModel
{
    func save(profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    func load(completion: @escaping (Profile, Error?) -> Void)
}

class ProfileModel: IProfileModel
{
    // MARK: - IProfileModel
    
    func save(profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    {
        gcdService.saveProfileData(profile, completion: completion)
    }
    
    func load(completion: @escaping (Profile, Error?) -> Void)
    {
        operationDataStoreService.loadProfileData(completion: completion)
    }
    
    // MARK: - Life cycle
    
    init(gcdService: IDataStore, operationDataStoreService: IDataStore)
    {
        self.gcdService = gcdService
        self.operationDataStoreService = operationDataStoreService
    }
    
    // MARK: - Private properties
    
    private let gcdService: IDataStore
    private let operationDataStoreService: IDataStore
}
