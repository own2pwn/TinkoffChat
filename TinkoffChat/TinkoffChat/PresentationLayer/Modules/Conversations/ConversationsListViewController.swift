//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import CoreData

enum ConversationsListTableViewSections: Int
{
    case offlineUsers = 0
    case onlineUsers = 1
    case all
}

final class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    NSFetchedResultsControllerDelegate
{
    // MARK: - Outlets

    @IBOutlet weak var conversationsTableView: UITableView!

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        conversationsTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        conversationsTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType)
    {
        switch type {
        case .insert:
            conversationsTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            conversationsTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            if let indexPath = newIndexPath
            {
                conversationsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath
            {
                conversationsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath
            {
                // swiftlint:disable:next force_cast
                let cell = conversationsTableView.cellForRow(at: indexPath) as! ConversationsListCell
                configureCell(cell, at: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath
            {
                conversationsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath
            {
                conversationsTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        }
        checkUser(anObject as? User)
    }

    // MARK: - Life cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        model.initFetchedResultsController(ignoringUserId: localUserId, self)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setupView()
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return model.numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // swiftlint:disable:next force_cast line_length
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReusabledentifier, for: indexPath) as! ConversationsListCell

        configureCell(cell, at: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return model.getTitleForSection(section)
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath)
        {
            selectedUser = model.fetchUser(at: indexPath)
            performSegue(withIdentifier: idShowDialogSegue, sender: cell)
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }

    // MARK: - Outlet actions

    func didTapNavBarProfileButton(_ sender: UIButton)
    {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idProfileVC")
        present(profileVC, animated: true, completion: nil)
    }

    // MARK: - Private methods

    // MARK: UI

    private func setupView()
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

    private func configureCell(_ cell: ConversationsListCell, at indexPath: IndexPath)
    {
        cell.selectionStyle = .none

        let userModel = model.fetchUserDisplayModel(at: indexPath)

        cell.userName = userModel.name
        cell.isUserOnline = userModel.isOnline
        cell.lastMessageText = userModel.lastMessageText
        cell.lastMessageDate = userModel.lastMessageDate
        cell.backgroundColor = cell.isUserOnline ? .CellYellowColor : .white
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let cell = sender as? ConversationsListCell,
            let dialogVC = segue.destination as? ConversationViewController
        {
            conversationViewController = dialogVC
            conversationViewController?.setSendMessageButtonEnabled(selectedUser.isOnline)
            dialogVC.navigationItem.title = cell.userName
            dialogVC.mpcService = mpcService
            dialogVC.selectedUser = selectedUser
        }
    }

    // MARK: Helping methods

    private func checkUser(_ user: User?)
    {
        guard let user = user,
            selectedUser != nil else { return }
        if user == selectedUser
        {
            conversationViewController?.setSendMessageButtonEnabled(user.isOnline)
        }
    }

    // MARK: - Private properties

    // MARK: Lazy

    private lazy var model: IConversationsListModel = {
        self.assembly.model
    }()

    // MARK: Stored

    private var selectedUser: User!

    private weak var conversationViewController: IConversationViewController?

    private let assembly = ConversationsListAssembly()

    private let localUserId = UIDevice.current.identifierForVendor!.uuidString

    private let cellReusabledentifier = "idDialogsCell"

    private let idShowDialogSegue = "idShowDialogSegue"

    // MARK: Services

    private lazy var mpcService: IMPCService = {
        self.assembly.mpcService
    }()
}
