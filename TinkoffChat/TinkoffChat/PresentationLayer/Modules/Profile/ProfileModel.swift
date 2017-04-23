//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

protocol IProfileModel
{
    func save(profile: ProfileDisplayModel, completion: @escaping (Bool, Error?) -> Void)
    func load(completion: @escaping (ProfileDisplayModel, Error?) -> Void)
}

struct ProfileDisplayModel
{
    let userName: String
    let aboutUser: String
    let userImage: UIImage
    let textColor: UIColor

    static func getDefaultProfile() -> ProfileDisplayModel
    {
        return ProfileDisplayModel(userName: "", aboutUser: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", userImage: #imageLiteral(resourceName: "profileImg"), textColor: .black)
    }
}

extension ProfileDisplayModel: Hashable
{
    var hashValue: Int
    {
        return userName.hashValue ^ aboutUser.hashValue ^ userImage.hashValue ^ textColor.hashValue
    }

    static func == (lhs: ProfileDisplayModel, rhs: ProfileDisplayModel) -> Bool
    {
        return lhs.hashValue == rhs.hashValue
    }
}

class ProfileModel: IProfileModel
{
    // MARK: - IProfileModel

    func save(profile: ProfileDisplayModel, completion: @escaping (Bool, Error?) -> Void)
    {
        gcdService.saveProfileData(profile, completion: completion)
    }

    func load(completion: @escaping (ProfileDisplayModel, Error?) -> Void)
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
