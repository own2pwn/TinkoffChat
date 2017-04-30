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

    static func getDefaultProfile() -> ProfileDisplayModel
    {
        return ProfileDisplayModel(userName: "", aboutUser: "\(aboutPlaceholder)", userImage: #imageLiteral(resourceName: "profileImg"))
    }

    private static let aboutPlaceholder = "Some info about"
}

extension ProfileDisplayModel: Hashable
{
    var hashValue: Int { return userName.hashValue ^ aboutUser.hashValue ^ userImage.hashValue }

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
