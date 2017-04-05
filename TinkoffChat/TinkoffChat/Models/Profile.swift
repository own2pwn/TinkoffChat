//
//  Profile.swift
//  TinkoffChat
//
//  Created by Evgeniy on 05.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

struct Profile
{
    let userName: String
    let aboutUser: String
    let userImage: UIImage
    let textColor: UIColor
    
    static func getDefaultProfile() -> Profile
    {
        return Profile(userName: "", aboutUser: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", userImage: #imageLiteral(resourceName: "profileImg"), textColor: .black)
    }
}

extension Profile: Hashable
{
    var hashValue: Int
    {
        return userName.hashValue ^ aboutUser.hashValue ^ userImage.hashValue ^ textColor.hashValue
    }
    
    static func == (lhs: Profile, rhs: Profile) -> Bool
    {
        return lhs.hashValue == rhs.hashValue
    }
}
