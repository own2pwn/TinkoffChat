//
//  IBaseConversation.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IBaseConversationCellDisplayModel
{
    var message: String? { get }
    var messageDate: Date? { get }
}

protocol IBaseModelDelegate: class
{
    func show(error message: String)
}
