//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Evgeniy on 05.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

protocol DataManager: class
{
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    func loadProfileData(completion: @escaping (Profile, Error?) -> Void)
}
