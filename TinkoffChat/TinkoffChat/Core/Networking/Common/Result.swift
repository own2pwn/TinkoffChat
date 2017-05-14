//
//  Result.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

enum Result<T>
{
    case success(T)
    case fail(String)
}
