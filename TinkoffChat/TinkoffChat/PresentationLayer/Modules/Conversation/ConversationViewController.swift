//
//  DialogController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import CoreData

protocol IConversationViewController: class
{
    func setSendMessageButtonEnabled(_ enabled: Bool)
}

final class ConversationViewController: UIViewController, UITableViewDataSource,
    NSFetchedResultsControllerDelegate, IConversationViewController
{
    // MARK: - Outlets

    @IBOutlet weak var conversationTableView: UITableView!

    @IBOutlet weak var messageTextView: UITextView!

    @IBOutlet weak var sendMessageButton: UIButton!

    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        conversationTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        conversationTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        let ip = IndexPath(row: model.messagesCount() - 1, section: 0)
        if type == .insert
        {
            conversationTableView.insertRows(at: [ip], with: .fade)
        }
    }

    // MARK: - IConversationViewController

    func setSendMessageButtonEnabled(_ enabled: Bool)
    {
        DispatchQueue.main.async
        {
            self.sendMessageButton.isEnabled = enabled
        }
    }

    // MARK: - Life cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        model.initFetchedResultsController(selectedUser, self)

        setupView()
        observeKeyboard()
    }

    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UITableViewDataSource

    func configureCell(_ cell: MessageCell, at indexPath: IndexPath)
    {
        let row = indexPath.row

        cell.selectionStyle = .none
        cell.backgroundColor = .CellLightYellowColor

        let message = model.fetchMessageDisplayModel(at: row)
        cell.messageText = message.text
        cell.messageDateLabel.text = Calendar.current.isDateInToday(message.date) ? message.date.extractTime() : message.date.extractDay()
        // swiftlint:disable:previous line_length
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        var cell = MessageCell()

        // swiftlint:disable force_cast
        if model.isIncomingMessage(row)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: receivedMessageCellId, for: indexPath) as! MessageCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: sentMessageCellId, for: indexPath) as! MessageCell
            // swiftlint:enable force_cast
        }
        configureCell(cell, at: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.messagesCount()
    }

    // MARK: - Outlet actions

    @IBAction func didPressSendMessageButton(_ sender: UIButton)
    {
        guard let text = messageTextView.text else { return }

        if !text.isEmpty
        {
            send(message: text)
        }
    }

    // MARK: - Private methods

    private func observeKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        mpcService.send(message: message, to: selectedUserId)
        { error in
            if error != nil
            {
                print("There was an eror while sending message: \(String(describing: error?.localizedDescription))")
            }
            else
            {
                model.saveMessage(message, receiverId: selectedUserId)
                messageTextView.text = nil
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

    internal func keyboardWillHide()
    {
        textViewBottomConstraint.constant = 0
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

    internal var selectedUserId: String!

    internal var selectedUser: User!
    {
        didSet
        {
            selectedUserId = selectedUser.userId
        }
    }

    private let currentDeviceUserID = UIDevice.current.identifierForVendor!.uuidString

    private let sentMessageCellId = "idSentMessage"

    private let receivedMessageCellId = "idReceivedMessage"

    // MARK: Services

    internal var mpcService: IMPCService!
}
