//
//  DialogController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

final class ConversationViewController: UIViewController, IConversationModelDelegate, UITableViewDataSource
{
    // MARK: - Outlets
    
    @IBOutlet weak var conversationTableView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Outlets actions
    
    @IBAction func didPressSendMessageButton(_ sender: UIButton)
    {
        guard let text = messageTextView.text else { return }
        
        if !text.isEmpty
        {
            send(message: text)
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupLogic()
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeState), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeState), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        loadMessages()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IConversationModelDelegate
    
    func didLostUser(userID: String)
    {
        if userID == selectedUserID
        {
            setSendMessageButtonEnabled(false)
        }
    }
    
    func didReceiveMessage(from userID: String, message: String)
    {
        let newMessage = Message(message: message, sender: userID, receiver: currentDeviceUserID)
        dataSource.append(newMessage)
        
        updateUI()
    }
    
    // MARK: - UITableViewDataSource
    
    func configureCell(_ cell: MessageCell, at indexPath: IndexPath)
    {
        let row = indexPath.row
        
        cell.selectionStyle = .none
        cell.backgroundColor = .CellLightYellowColor
        
        let message = dataSource[row]
        cell.messageText = message.message
        cell.messageDateLabel.text = Calendar.current.isDateInToday(message.sentDate) ? message.sentDate.extractTime() : message.sentDate.extractDay()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        var cell = MessageCell()
        
        let msgSender = dataSource[row].sender
        
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
        return dataSource.count
    }
    
    // MARK: - Private methods
    
    private func setupLogic()
    {
        model.delegate = self
    }
    
    private func loadMessages()
    {
        model.getMessages(for: selectedUserID, with: currentDeviceUserID)
        { messages in
            dataSource = messages
            
            updateUI()
        }
    }
    
    private func updateUI()
    {
        DispatchQueue.main.async
        {
            self.conversationTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    // MARK: View setup
    
    private func setupView()
    {
        conversationTableView.tableFooterView = UIView()
        conversationTableView.estimatedRowHeight = 44
        conversationTableView.rowHeight = UITableViewAutomaticDimension
        
        conversationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        conversationTableView.scrollIndicatorInsets = conversationTableView.contentInset
        conversationTableView.backgroundColor = UIColor.CellLightYellowColor
        
        navigationController?.hidesBarsOnSwipe = false
        
        let onViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        view.addGestureRecognizer(onViewTapGesture)
    }
    
    internal func onViewTap()
    {
        view.endEditing(true)
    }
    
    private func send(message: String)
    {
        mpcService.send(message: message, to: selectedUserID)
        { error in
            if error != nil
            {
                print("There was an eror while sending message: \(String(describing: error?.localizedDescription))")
            }
            else
            {
                let newMessage = Message(message: message, sender: currentDeviceUserID, receiver: selectedUserID)
                dataSource.append(newMessage)
                
                DispatchQueue.main.async
                {
                    self.messageTextView.text = nil
                    self.conversationTableView.reloadSections(IndexSet(integer: 0), with: .fade)
                }
            }
        }
    }
    
    internal func keyboardWillShow(_ notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            textViewBottomConstraint.constant = keyboardSize.size.height
        }
    }
    
    internal func keyboardDidChangeState()
    {
        let messagesCount = dataSource.count
        
        if messagesCount > 0
        {
            conversationTableView.scrollToRow(at: IndexPath(row: messagesCount - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    internal func keyboardWillHide()
    {
        textViewBottomConstraint.constant = 0
    }
    
    private func setSendMessageButtonEnabled(_ enabled: Bool)
    {
        DispatchQueue.main.async
        {
            self.sendMessageButton.isEnabled = enabled
        }
    }
    
    // MARK: - Private properties
    
    // MARK: Lazy
    
    private lazy var assembly: ConversationAssembly = {
        ConversationAssembly(with: self.mpcService)
    }()
    
    private lazy var model: IConversationModel = {
        self.assembly.model
    }()
    
    // MARK: Stored
    
    internal var mpcService: IMPCService!
    
    internal var selectedUserID: String!
    
    private var dataSource = [Message]()
    
    private let currentDeviceUserID = UIDevice.current.identifierForVendor!.uuidString
    
    private let sentMessageCellId = "idSentMessage"
    private let receivedMessageCellId = "idReceivedMessage"
}
