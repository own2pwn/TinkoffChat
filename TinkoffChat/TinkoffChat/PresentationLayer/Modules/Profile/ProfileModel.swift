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

    func save(profile: ProfileDisplayModel, completion: @escaping (Bool, Error?) -> Void)
    {
        let imageData = UIImagePNGRepresentation(profile.userImage) as NSData?

        let entityModel = ProfileEntityModel(aboutUser: profile.aboutUser,
                                             userImage: imageData, userName: profile.userName)

        coreDataWorker.updateOrInsert(entity: entityModel)
        { error in
            if let error = error
            {
                print("Couldn't save profile data! Error: \(error.localizedDescription)")
                completion(false, error)
            }
            else { completion(true, nil) }
        }
    }

    func load(completion: @escaping (ProfileDisplayModel, Error?) -> Void)
    {
        coreDataWorker.get(with: nil, sortDescriptors: nil, fetchLimit: 1)
        { (result: Result<[ProfileEntityModel]>) in
            switch result
            {
            case .fail(let error):
                print("Couldn't load profile data! Error: \(error)")
                break
            case .success(let profile):
                if let profile = profile.first?.validate()
                {
                    if let imageData = profile.userImage as Data?
                    {
                        let image = UIImage(data: imageData) ?? #imageLiteral(resourceName: "profileImg")
                        let displayModel = ProfileDisplayModel(userName: profile.userName ?? "",
                                                               aboutUser: profile.aboutUser ?? "", userImage: image)
                        completion(displayModel, nil)
                    }
                }
                else // no saved data
                {
                    completion(ProfileDisplayModel.defaultModel(), nil)
                }
                break
            }
        }
    }

    // MARK: - Life cycle

    init(coreDataWorker: ICoreDataWorker)
    {
        self.coreDataWorker = coreDataWorker
    }

    // MARK: - Private properties

    private let coreDataWorker: ICoreDataWorker
}
