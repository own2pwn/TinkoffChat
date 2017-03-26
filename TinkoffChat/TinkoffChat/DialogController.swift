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
        
        if cell.reuseIdentifier == sentMessageCellId
        {
            switch row
            {
            case 0:
                cell.messageText = String.randomString(1)
                
                break
            case 2:
                cell.messageText = String.randomString(30)
                cell.messageBubbleView.layer.cornerRadius = cell.messageBubbleView.frame.height / 4
                
                break
            case 4:
                cell.messageText = String.randomString(300)
                break
            default:
                break
            }
        }
        else
        {
            switch row - 1
            {
            case 0:
                cell.messageText = String.randomString(1)
                break
            case 2:
                cell.messageText = String.randomString(30)
                break
            case 4:
                cell.messageText = String.randomString(300)
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
