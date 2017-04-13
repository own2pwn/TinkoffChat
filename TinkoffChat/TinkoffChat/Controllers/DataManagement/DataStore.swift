//
//  DataStore.swift
//  TinkoffChat
//
//  Created by Evgeniy on 05.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class DataStore: NSObject
{
    static func saveProfileData(_ profile: Profile, completion: (Bool, Error?) -> Void)
    {
        if let imageData = UIImagePNGRepresentation(profile.userImage)
        {
            let dataDict = ["uName": profile.userName, "about": profile.aboutUser, "img": imageData, "color": profile.textColor] as [String: Any]
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
    
    static func loadProfileData(completion: (Profile, Error?) -> Void)
    {
        do
        {
            let savedData = try Data(contentsOf: getSettingsFilePath())
            let unarchData = NSKeyedUnarchiver.unarchiveObject(with: savedData) as! [String: Any]
            let imageData = UIImage(data: unarchData["img"] as! Data) ?? #imageLiteral(resourceName: "profileImg")
            
            let ret = Profile(userName: unarchData["uName"] as! String, aboutUser: unarchData["about"] as! String, userImage: imageData, textColor: unarchData["color"] as! UIColor)
            completion(ret, nil)
        }
        catch
        {
            completion(Profile.getDefaultProfile(), error)
        }
    }
    
    // MARK: - Helping stuff
    
    enum DataStoreError: Error
    {
        case noImageData
        case noAvailableSavedProfileFound
    }
    
    static func getSettingsFilePath() -> URL
    {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let settingsFileName = "settings.bin"
        let ret = docDir.appendingPathComponent(settingsFileName)
        
        return ret
    }
}
