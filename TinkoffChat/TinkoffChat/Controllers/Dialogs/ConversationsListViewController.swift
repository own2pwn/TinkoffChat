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

final class ConversationsListViewController: UIViewController, IBaseConversationModelDelegate, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Outlets

    @IBOutlet weak var conversationsTableView: UITableView!

    // MARK: - Actions

    func didTapNavBarProfileButton(_ sender: UIButton)
    {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idProfileVC")
        present(profileVC, animated: true, completion: nil)
    }

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
        model.delegate = self

        setupView()
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let cell = sender as? DialogCell, let dialogVC = segue.destination as? ConversationController
        {
            dialogVC.navigationItem.title = cell.userName
            dialogVC.mpcService = mpcService
            dialogVC.selectedUserID = selectedUserID
            dialogVC.dialogsController = self
        }
    }

    // MARK: - IConversationsListModelDelegate

    func updateView(with data: [ConversationDataSourceType])
    {
        dataSource = data
        updateUI()
    }

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
        let model = dataSource[row].model

        cell.userName = model.userName
        cell.isUserOnline = true

        let relatedMessage = dataSource[row].model.messages.last

        cell.lastMessageText = relatedMessage?.message
        cell.lastMessageDate = relatedMessage?.sentDate
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
            selectedUserID = dataSource[indexPath.row].userID
            performSegue(withIdentifier: idShowDialogSegue, sender: cell)
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }

    // MARK: - Private methods

    private func updateUI()
    {
        DispatchQueue.main.async
        {
            self.conversationsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }

    // MARK: - Private properties

    // MARK: Lazy

    private lazy var model: IConversationsListModel = {
        self.assembly.model
    }()

    private lazy var mpcService: IMPCService = {
        self.assembly.mpcService
    }()

    // MARK: Stored

    private let assembly = ConversationsListAssembly()

    private var dataSource = [ConversationDataSourceType]()

    private var selectedUserID = ""
    private let currentDeviceUserID = UIDevice.current.identifierForVendor!.uuidString

    private let cellReusabledentifier = "idDialogsCell"
    private let numOfSections = 1
    private let idShowDialogSegue = "idShowDialogSegue"
}
