//
//  DialogCell.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell, DialogCellModel
{
    // MARK: - DialogCellModel
    
    var userName: String?
    {
        get
        {
            guard userNameLabel != nil else { return nil }
            return userNameLabel.text
        }
        set
        {
            guard userNameLabel != nil else { return }
            userNameLabel.text = newValue
        }
    }
    
    var lastMessageDate: Date?
    {
        get { return _lastMessageDate }
        set
        {
            _lastMessageDate = newValue
            guard lastMessageDateLabel != nil, let _lastMessageDate = _lastMessageDate else { return }
            
            let isDateToday = currentCalendar.isDateInToday(_lastMessageDate)
            
            lastMessageDateLabel.text = isDateToday ? _lastMessageDate.extractTime() : _lastMessageDate.extractDay()
        }
    }
    
    var hasUnreadMessages: Bool
    {
        get { return _hasUnreadMessages }
        set
        {
            _hasUnreadMessages = newValue
            guard lastMessageLabel != nil else { return }
            lastMessageLabel.font = _hasUnreadMessages ? UIFont.appMainFontMedium : UIFont.appMainFont
        }
    }
    
    var lastMessageText: String?
    {
        get
        {
            guard lastMessageLabel != nil else { return nil }
            return lastMessageLabel.text
        }
        set
        {
            guard lastMessageLabel != nil else { return }
            
            if newValue == nil
            {
                lastMessageDateLabel.isHidden = true
                lastMessageLabel.text = "No messages yet"
                lastMessageLabel.font = UIFont.appMainLightFont
            }
            else
            {
                lastMessageDateLabel.isHidden = false
                lastMessageLabel.text = newValue
                lastMessageLabel.font = UIFont.appMainFont
            }
        }
    }
    
    var isUserOnline: Bool
    {
        get { return _isUserOnline }
        set { _isUserOnline = newValue }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    // MARK: - Properties
    
    let currentCalendar = Calendar.current
    
    private var _lastMessageDate: Date?
    private var _hasUnreadMessages = false
    private var _isUserOnline = false
}
