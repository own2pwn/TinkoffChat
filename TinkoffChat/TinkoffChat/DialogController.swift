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
    }
}
