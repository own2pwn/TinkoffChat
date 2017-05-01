//
//  ModelValidable.swift
//  TinkoffChat
//
//  Created by Evgeniy on 01.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol ModelValidable
{
    associatedtype Entity
    func validate() -> Entity?
}
