//
//  DialogCellModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

protocol DialogCellModel: class
{
    var userName: String? { get set }
    var lastMessageText: String? { get set }
    var lastMessageDate: Date? { get set }
    var isUserOnline: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class CustomDialogCell: DialogCellModel
{
    internal var lastMessageText: String?
    {
        get { return _lastMessageText }
        set { _lastMessageText = newValue }
    }
    
    internal var userName: String?
    {
        get { return _userName }
        set { _userName = newValue }
    }
    
    internal var lastMessageDate: Date?
    {
        get { return _lastMessageDate }
        set { _lastMessageDate = newValue }
    }
    
    internal var isUserOnline: Bool
    {
        get { return _isUserOnline }
        set { _isUserOnline = newValue }
    }
    
    internal var hasUnreadMessages: Bool
    {
        get { return _hasUnreadMessages }
        set { _hasUnreadMessages = newValue }
    }
    
    public init(lastMessageText aText: String?, userName aName: String?, lastMessageDate aDate: Date?, isUserOnline aOnline: Bool, hasUnreadMessages unreadMessages: Bool)
    {
        lastMessageText = aText
        userName = aName
        lastMessageDate = aDate
        isUserOnline = aOnline
        hasUnreadMessages = unreadMessages
    }
    
    private var _lastMessageText: String?
    private var _userName: String?
    private var _lastMessageDate: Date?
    private var _isUserOnline = false
    private var _hasUnreadMessages = false
}
