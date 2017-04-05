//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Evgeniy on 05.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class GCDDataManager: DataManager
{
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void = { _, _ in })
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            DataStore.saveProfileData(profile, completion: { bSuccess, err in
                DispatchQueue.main.async
                {
                    completion(bSuccess, err)
                }
            })
        }
    }

    func loadProfileData(completion: @escaping (Profile, Error?) -> Void = { _, _ in })
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            DataStore.loadProfileData(completion: { profile, err in
                DispatchQueue.main.async
                {
                    completion(profile, err)
                }
            })
        }
    }
}
