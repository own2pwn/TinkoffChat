//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, MessageCellModel
{
    var messageText: String?
    {
        get
        {
            guard messageLabel != nil else { return nil }
            return messageLabel.text
        }
        set
        {
            guard messageLabel != nil else { return }
            messageLabel.text = newValue
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
}
