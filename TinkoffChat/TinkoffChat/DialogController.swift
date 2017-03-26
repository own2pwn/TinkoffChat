//
//  DialogController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

fileprivate let sentMessageCellId = "idSentMessage"
fileprivate let receivedMessageCellId = "idReceivedMessage"

class DialogController: UIViewController
{
    // MARK: - Outlets
    
    @IBOutlet weak var dialogTableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView()
    {
        dialogTableView.tableFooterView = UIView()
        dialogTableView.estimatedRowHeight = 44
        dialogTableView.rowHeight = UITableViewAutomaticDimension
        
        dialogTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        dialogTableView.scrollIndicatorInsets = dialogTableView.contentInset
        dialogTableView.backgroundColor = UIColor.CellLightYellowColor
        
        navigationController?.hidesBarsOnSwipe = false
    }
}
// MARK: - Extensions

extension DialogController: UITableViewDataSource
{
    func configureCell(_ cell: MessageCell, at indexPath: IndexPath)
    {
        let row = indexPath.row
        
        cell.selectionStyle = .none
        cell.backgroundColor = .CellLightYellowColor
        
        let messageBubble = UIView()
        messageBubble.backgroundColor = UIColor.CellYellowColor
        messageBubble.layer.cornerRadius = 15
        messageBubble.tag = 1
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        if let view = cell.viewWithTag(1)
        {
            view.removeFromSuperview()
        }
        
        // TODO: move calculation of est. rect after cell's configuration
        // and switch by cell's message text len.
        
        if cell.reuseIdentifier == sentMessageCellId
        {
            switch row
            {
            case 0:
                cell.messageText = String.randomString(1)
                cell.insertSubview(messageBubble, at: 0)
                
                let estRect = NSString(string: cell.messageText!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.appMainFont], context: nil)
                let bubbleOrigin = CGPoint(x: view.frame.width - estRect.width - 12, y: 4)
                let bubbleSize = CGSize(width: estRect.width + 8, height: estRect.height + 8)
                
                messageBubble.frame = CGRect(origin: bubbleOrigin, size: bubbleSize)
                
                break
            case 2:
                cell.messageText = String.randomString(30)
                cell.insertSubview(messageBubble, at: 0)
                
                let estRect = NSString(string: cell.messageText!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.appMainFont], context: nil)
                let bubbleOrigin = CGPoint(x: view.frame.width - estRect.width - 12, y: 4)
                let bubbleSize = CGSize(width: estRect.width + 8, height: estRect.height + 8)
                
                messageBubble.frame = CGRect(origin: bubbleOrigin, size: bubbleSize)
                break
            case 4:
                cell.messageText = String.randomString(300)
                cell.insertSubview(messageBubble, at: 0)
                
                let estRect = NSString(string: cell.messageText!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.appMainFont], context: nil)
                let bubbleOrigin = CGPoint(x: view.frame.width - estRect.width - 12, y: 4)
                let bubbleSize = CGSize(width: estRect.width + 8, height: estRect.height + 36)
                
                messageBubble.frame = CGRect(origin: bubbleOrigin, size: bubbleSize)
                break
            default:
                break
            }
        }
        else
        {
            messageBubble.backgroundColor = .CellPowderColor
            let bubbleOrigin = CGPoint(x: 4, y: 4)
            switch row - 1
            {
            case 0:
                cell.messageText = String.randomString(1)
                cell.insertSubview(messageBubble, at: 0)
                
                let estRect = NSString(string: cell.messageText!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.appMainFont], context: nil)
                let bubbleSize = CGSize(width: estRect.width + 8, height: estRect.height + 8)
                
                messageBubble.frame = CGRect(origin: bubbleOrigin, size: bubbleSize)
                break
            case 2:
                cell.messageText = String.randomString(30)
                cell.insertSubview(messageBubble, at: 0)
                
                let estRect = NSString(string: cell.messageText!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.appMainFont], context: nil)
                let bubbleSize = CGSize(width: estRect.width + 8, height: estRect.height + 8)
                
                messageBubble.frame = CGRect(origin: bubbleOrigin, size: bubbleSize)
                break
            case 4:
                cell.messageText = String.randomString(300)
                cell.insertSubview(messageBubble, at: 0)
                
                let estRect = NSString(string: cell.messageText!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.appMainFont], context: nil)
                let bubbleSize = CGSize(width: estRect.width + 8, height: estRect.height + 36)
                
                messageBubble.frame = CGRect(origin: bubbleOrigin, size: bubbleSize)
                break
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        var cell = MessageCell()
        
        if row % 2 == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: sentMessageCellId, for: indexPath) as! MessageCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: receivedMessageCellId, for: indexPath) as! MessageCell
        }
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
}

// MARK: Other

extension DialogController
{
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
