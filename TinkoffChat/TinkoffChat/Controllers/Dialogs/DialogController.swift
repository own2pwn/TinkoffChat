//
//  DialogController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class DialogController: UIViewController, UITableViewDataSource
{
    // MARK: - Communication
    
    internal var communicator: MultipeerCommunicator!
    
    internal var selectedUserID: String!
    
    weak var dialogsController: DialogsController!
    
    internal var messages = [Message]()
    {
        didSet
        {
            messagesCount = messages.count
            DispatchQueue.main.async
            {
                self.dialogTableView.reloadSections(IndexSet(integer: 0), with: .fade)
                let nPath = IndexPath(row: self.messagesCount - 1, section: 0)
                self.dialogTableView.scrollToRow(at: nPath, at: .middle, animated: true)
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var dialogTableView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUserFound(_:)), name: .DidFoundUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onMessageReceive(_:)), name: .DidReceiveMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUserLost(_:)), name: .DidLostUser, object: nil)
        
        loadMessages()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View setup
    
    func setupView()
    {
        dialogTableView.tableFooterView = UIView()
        dialogTableView.estimatedRowHeight = 44
        dialogTableView.rowHeight = UITableViewAutomaticDimension
        
        dialogTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        dialogTableView.scrollIndicatorInsets = dialogTableView.contentInset
        dialogTableView.backgroundColor = UIColor.CellLightYellowColor
        
        navigationController?.hidesBarsOnSwipe = false
        
        let onViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        view.addGestureRecognizer(onViewTapGesture)
    }
    
    func onViewTap()
    {
        view.endEditing(true)
    }
    
    // MARK: - MPC KVO
    
    func onUserFound(_ notification: NSNotification)
    {
        guard let info = notification.userInfo as? [String: String?] else { return }
        
        if let userID = info[KDiscoveryInfo.UserID] as? String
        {
            if userID == selectedUserID
            {
                setSendMessageButtonEnabled(true)
            }
        }
    }
    
    func onUserLost(_ notification: NSNotification)
    {
        guard let userID = notification.userInfo?[KDiscoveryInfo.UserID] as? String else { return }
        if userID == selectedUserID
        {
            setSendMessageButtonEnabled(false)
        }
    }
    
    func onMessageReceive(_ notification: NSNotification)
    {
        guard let info = notification.userInfo as? [String: String] else { return }
        
        if let text = info[KMessageInfo.Text], let sender = info[KMessageInfo.FromUser], let receiver = info[KMessageInfo.ToUser]
        {
            if sender == selectedUserID && receiver == currentDeviceUserID
            {
                messages.append(Message(message: text, sentDate: Date(), sender: sender, receiver: receiver))
            }
        }
    }
    
    // MARK: - Methods
    
    func loadMessages()
    {
        if let messages = dialogsController.getMessagesForUser(selectedUserID)
        {
            self.messages = messages
        }
        messagesCount = messages.count
    }
    
    func send(message: String)
    {
        communicator.sendMessage(string: message, to: selectedUserID)
        { sent, error in
            print("`Msg was sent: \(sent) | with error: \(String(describing: error?.localizedDescription))")
            
            if error == nil
            {
                let msg = Message(message: message, sentDate: Date(), sender: self.currentDeviceUserID, receiver: self.selectedUserID)
                DispatchQueue.main.async
                {
                    self.messages.append(msg)
                    self.dialogsController.appendMessage(to: self.selectedUserID, message: msg)
                    self.messageTextView.text = nil
                }
            }
        }
    }
    
    func keyboardWillShow(_ notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            textViewBottomConstraint.constant = keyboardSize.size.height
        }
    }
    
    func keyboardDidShow()
    {
        if messagesCount > 0
        {
            dialogTableView.scrollToRow(at: IndexPath(row: messagesCount - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func keyboardWillHide()
    {
        textViewBottomConstraint.constant = 0
    }
    
    func keyboardDidHide(_ notification: NSNotification)
    {
        if messagesCount > 0
        {
            dialogTableView.scrollToRow(at: IndexPath(row: messagesCount - 1, section: 0), at: .middle, animated: true)
        }
        
    }
    
    func setSendMessageButtonEnabled(_ enabled: Bool)
    {
        DispatchQueue.main.async
        {
            self.sendMessageButton.isEnabled = enabled
        }
    }
    
    // MARK: - Outlets actions
    
    @IBAction func didPressSendMessageButton(_ sender: UIButton)
    {
        guard let text = messageTextView.text else { return }
        
        if !text.isEmpty
        {
            send(message: text)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func configureCell(_ cell: MessageCell, at indexPath: IndexPath)
    {
        let row = indexPath.row
        
        cell.selectionStyle = .none
        cell.backgroundColor = .CellLightYellowColor
        
        let message = messages[row]
        cell.messageText = message.message
        cell.messageDateLabel.text = Calendar.current.isDateInToday(message.sentDate) ? message.sentDate.extractTime() : message.sentDate.extractDay()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        var cell = MessageCell()
        
        let msgSender = messages[row].sender
        
        if msgSender == currentDeviceUserID
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
        return messagesCount
    }
    
    // MARK: - Private properties
    
    private var messagesCount = 0
    private let currentDeviceUserID = UIDevice.current.identifierForVendor!.uuidString
    
    private let sentMessageCellId = "idSentMessage"
    private let receivedMessageCellId = "idReceivedMessage"
}
