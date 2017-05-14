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
    func loadProfileModel(completion: @escaping (ProfileDisplayModel, Error?) -> Void)

    func save(profile: ProfileDisplayModel,
              completion: @escaping (Bool, Error?) -> Void)
}

struct ProfileDisplayModel
{
    let userName: String
    let aboutUser: String
    let userImage: UIImage

    static func defaultModel() -> ProfileDisplayModel
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

    func loadProfileModel(completion: @escaping (ProfileDisplayModel, Error?) -> Void)
    {
        coreDataService.get(predicate: nil, sortDescriptors: nil, fetchLimit: 1)
        { (result: Result<[ProfileEntityModel]>) in
            switch result
            {
            case .fail(let error):
                print("Couldn't load profile data! Error: \(error)")
                break
            case .success(let profile):
                if let profile = profile.first?.validate()
                {
                    let model = self.convertEntityToModel(profile)
                    completion(model, nil)
                }
                else // no saved data
                {
                    completion(ProfileDisplayModel.defaultModel(), nil)
                }
                break
            }
        }
    }

    func save(profile: ProfileDisplayModel,
              completion: @escaping (Bool, Error?) -> Void)
    {
        dataStoreService.saveImageOnDisk(profile.userImage)
        { error, path in
            guard error == nil, let path = path else
            {
                completion(false, error)
                return
            }
            let entityModel = ProfileEntityModel(aboutUser: profile.aboutUser,
                                                 imagePath: path,
                                                 userName: profile.userName)

            self.coreDataService.updateOrInsert(entity: entityModel)
            { error in
                if let error = error
                {
                    print("Couldn't save profile data! Error: \(error.localizedDescription)")
                    completion(false, error)
                }
                else { completion(true, nil) }
            }
        }
    }

    // MARK: - Life cycle

    init(coreDataService: ICoreDataService,
         dataStoreService: IDataStoreService)
    {
        self.coreDataService = coreDataService
        self.dataStoreService = dataStoreService
    }

    // MARK: - Private methods

    private func convertEntityToModel(_ entity: ProfileEntityModel) -> ProfileDisplayModel
    {
        let userName = entity.userName ?? ""
        let aboutUser = entity.aboutUser ?? ""
        var image: UIImage
        if entity.imagePath == nil { image = #imageLiteral(resourceName: "profileImg") }
        else
        {
            image = dataStoreService.getImageFromDisk(by: entity.imagePath!) ?? #imageLiteral(resourceName: "profileImg")
        }
        return ProfileDisplayModel(userName: userName,
                                   aboutUser: aboutUser,
                                   userImage: image)
    }

    // MARK: - Private properties

    private let coreDataService: ICoreDataService

    private let dataStoreService: IDataStoreService
}
