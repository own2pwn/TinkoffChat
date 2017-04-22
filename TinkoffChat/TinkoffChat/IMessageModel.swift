//
//  IMessageModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IMessageModel
{
    var sender: String { get set }
    var receiver: String { get set }
    var message: String { get set }
}
