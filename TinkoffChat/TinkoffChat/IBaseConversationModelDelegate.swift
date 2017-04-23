//
//  IBaseConversationModelDelegate.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IBaseConversationModelDelegate: class
{
    func updateView(with data: [ConversationDataSourceType])
}
