//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

final class MessageCell: UITableViewCell, MessageCellModel
{
    // MARK: - MessageCellModel
    
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
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageBubbleView: UIView!
    
    @IBOutlet weak var messageDateLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        messageBubbleView.layer.cornerRadius = messageBubbleView.frame.height / 2
    }
}
