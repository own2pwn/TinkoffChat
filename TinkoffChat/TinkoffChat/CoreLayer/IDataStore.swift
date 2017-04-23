//
//  IDataStore.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IDataStore
{
    func saveProfileData(_ profile: ProfileDisplayModel, completion: @escaping (Bool, Error?) -> Void)
    func loadProfileData(completion: @escaping (ProfileDisplayModel, Error?) -> Void)
}
