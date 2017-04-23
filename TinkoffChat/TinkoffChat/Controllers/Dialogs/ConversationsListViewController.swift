//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

enum ConversationsListTableViewSections: Int
{
    case offlineUsers = 0
    case onlineUsers = 1
    case all
}

class ConversationsListViewController: UIViewController, IMPCServiceDelegate, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Outlets

    @IBOutlet weak var conversationsTableView: UITableView!

    // MARK: - Communication

    //    private var messages = [String: [Message]]()
    //    {
    //        didSet
    //        {
    //            updateLastMessageDate()
    //            updateUI()
    //        }
    //    }

    // MARK: - Life cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupLogic()
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup

    func setupLogic()
    {
        //=== new
        mpcService.delegate = self

        setupView()
    }

    // MARK: - IMPCServiceDelegate

    func append(message: String, sender: String)
    {
    }

    func append(userID: String, userName: String?)
    {
    }

    func remove(userID: String)
    {
    }

    func log(error message: String)
    {
        print("There was an error!: \(message)")
    }

    func setupView()
    {
        conversationsTableView.tableFooterView = UIView()
        conversationsTableView.estimatedRowHeight = 44
        conversationsTableView.rowHeight = UITableViewAutomaticDimension

        navigationController?.navigationBar.barTintColor = .CellYellowColor
        navigationController?.hidesBarsOnSwipe = true

        let navBarProfileButton = UIButton()
        navBarProfileButton.addTarget(self, action: #selector(didTapNavBarProfileButton), for: .touchUpInside)
        navBarProfileButton.setImage(#imageLiteral(resourceName: "navBarProfileImg"), for: .normal)
        navBarProfileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBarProfileButton)
    }

    // MARK: - UI helping functions

    //    func peersSorter(_ p1: Peer, _ p2: Peer) -> Bool
    //    {
    //        let d1 = p1.lastMessageDate ?? Date(timeIntervalSince1970: 0)
    //        let d2 = p2.lastMessageDate ?? Date(timeIntervalSince1970: 0)
    //        let n1 = p1.userName?.lowercased() ?? "Z"
    //        let n2 = p2.userName?.lowercased() ?? "Z"
    //
    //        if d1 == d2
    //        {
    //            return n1 < n2
    //        }
    //        return d1 > d2
    //    }

    //    func updateLastMessageDate()
    //    {
    //        for message in messages
    //        {
    //            if let index = getIndexOfPeer(by: message.key)
    //            {
    //                availablePeers[index].lastMessageDate = message.value.last?.sentDate
    //            }
    //        }
    //    }

    func updateUI()
    {
        DispatchQueue.main.async
        {
            self.conversationsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }

    // MARK: - MPC

    //    func onUserFound(_ notification: NSNotification)
    //    {
    //        guard let info = notification.userInfo as? [String: String?] else { return }
    //
    //        if let userID = info[KDiscoveryInfo.UserID] as? String, let userName = info[KDiscoveryInfo.UserName]
    //        {
    //            appendPeerIfNotExists(by: userID, with: userName)
    //        }
    //    }
    //
    //    func onUserLost(_ notification: NSNotification)
    //    {
    //        guard let userID = notification.userInfo?[KDiscoveryInfo.UserID] as? String else { return }
    //        removePeer(by: userID)
    //    }
    //
    //    func onMessageReceive(_ notification: NSNotification)
    //    {
    //        guard let info = notification.userInfo as? [String: String] else { return }
    //
    //        if let text = info[KMessageInfo.Text], let sender = info[KMessageInfo.FromUser], let receiver = info[KMessageInfo.ToUser]
    //        {
    //            let newMessage = Message(message: text, sentDate: Date(), sender: sender, receiver: receiver)
    //            appendMessage(to: sender, message: newMessage)
    //        }
    //    }

    // MARK: Helping functions

    //    func appendPeerIfNotExists(by userID: String, with userName: String?)
    //    {
    //        for peer in availablePeers
    //        {
    //            if peer.userID == userID { return }
    //        }
    //        availablePeers.append(Peer(userID: userID, userName: userName, lastMessageDate: nil))
    //    }
    //
    //    func appendMessage(to userID: String, message: Message)
    //    {
    //        guard messages[userID] != nil else
    //        {
    //            messages[userID] = [message]
    //            return
    //        }
    //        messages[userID]!.append(message)
    //    }
    //
    //    func getIndexOfPeer(by userID: String) -> Int?
    //    {
    //        for it in 0..<availablePeers.count where availablePeers[it].userID == userID { return it }
    //
    //        return nil
    //    }
    //
    //    func getMessagesForUser(_ userID: String) -> [Message]?
    //    {
    //        return messages[userID]
    //    }
    //
    //    func removePeer(by userID: String)
    //    {
    //        for it in 0..<availablePeers.count where availablePeers[it].userID == userID
    //        {
    //            availablePeers.remove(at: it)
    //            return
    //        }
    //    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return numOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return dataSource.count
        }
        return 0
    }

    // MARK: UI configuration

    func configureCell(_ cell: DialogCell, at indexPath: IndexPath)
    {
        cell.selectionStyle = .none

        let row = indexPath.row
        let peer = dataSource[row]

        cell.lastMessageText = peer.message
        cell.lastMessageDate = peer.messageDate
        cell.userName = peer.userName
        cell.isUserOnline = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReusabledentifier, for: indexPath) as! DialogCell

        configureCell(cell, at: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0
        {
            return "Online"
        }
        return "History"
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath)
        {
            //            selectedUserID = availablePeers[indexPath.row].userID
            performSegue(withIdentifier: idShowDialogSegue, sender: cell)
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }

    // MARK: - Actions

    func didTapNavBarProfileButton(_ sender: UIButton)
    {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idProfileVC")
        present(profileVC, animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let cell = sender as? DialogCell, let dialogVC = segue.destination as? DialogController
        {
            dialogVC.navigationItem.title = cell.userName
            //            dialogVC.communicator = communicator
            dialogVC.selectedUserID = selectedUserID
            dialogVC.dialogsController = self
        }
    }

    // MARK: - Private properties

    // MARK: Lazy

    private let assembly = ConversationsListAssembly()

    private lazy var model: IConversationsListModel = {
        self.assembly.model
    }()

    private lazy var mpcService: IMPCService = {
        self.assembly.mpcService
    }()

    // MARK: Stored

    private var dataSource = [ConversationsListCellDisplayModel]()

    private var selectedUserID = ""
    private let currentDeviceUserID = UIDevice.current.identifierForVendor!.uuidString

    private let cellReusabledentifier = "idDialogsCell"
    private let numOfSections = 1
    private let idShowDialogSegue = "idShowDialogSegue"
}
