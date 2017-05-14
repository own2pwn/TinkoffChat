//
//  CommunicationHelper.swift
//  TinkoffChat
//
//  Created by Evgeniy on 09.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

// swiftlint:disable line_length

import Foundation

protocol ICommunicationHelper
{
    static func generateUniqueId() -> String
}

final class CommunicationHelper
{
    static func generateUniqueId() -> String
    {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
