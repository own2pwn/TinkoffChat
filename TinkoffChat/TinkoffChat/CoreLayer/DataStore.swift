//
//  DataStore.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

final class DataStore: IDataStore
{
    func saveProfileData(_ profile: ProfileDisplayModel, completion: @escaping (Bool, Error?) -> Void)
    {
        if let imageData = UIImagePNGRepresentation(profile.userImage)
        {
            let dataDict = ["uName": profile.userName, "about": profile.aboutUser,
                            "img": imageData] as [String: Any]

            let archData = NSKeyedArchiver.archivedData(withRootObject: dataDict)
            do
            {
                try archData.write(to: getSettingsFilePath(), options: .atomic)
            }
            catch
            {
                completion(false, error)
            }
            completion(true, nil)
        }
        else
        {
            completion(false, DataStoreError.noImageData)
        }
    }

    func loadProfileData(completion: @escaping (ProfileDisplayModel, Error?) -> Void)
    {
        do
        {
            let savedData = try Data(contentsOf: getSettingsFilePath())
            let unarchData = NSKeyedUnarchiver.unarchiveObject(with: savedData) as! [String: Any]
            let imageData = UIImage(data: unarchData["img"] as! Data) ?? #imageLiteral(resourceName: "profileImg")

            let ret = ProfileDisplayModel(userName: unarchData["uName"] as! String,
                                          aboutUser: unarchData["about"] as! String,
                                          userImage: imageData)
            completion(ret, nil)
        }
        catch
        {
            completion(ProfileDisplayModel.defaultModel(), error)
        }
    }

    // MARK: - Helping stuff

    private enum DataStoreError: Error
    {
        case noImageData
        case noAvailableSavedProfileFound
    }

    private func getSettingsFilePath() -> URL
    {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let settingsFileName = "settings.bin"
        let ret = docDir.appendingPathComponent(settingsFileName)

        return ret
    }

}
