//
//  DialogsController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class DialogsController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Outlets

    @IBOutlet weak var dialogsTableView: UITableView!

    // MARK: - Properties

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

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    // MARK: - Setup

    func setupLogic()
    {
        setupView()
    }

    func setupView()
    {
        dialogsTableView.tableFooterView = UIView()
        dialogsTableView.estimatedRowHeight = 44
        dialogsTableView.rowHeight = UITableViewAutomaticDimension

        navigationController?.navigationBar.barTintColor = .CellYellowColor
        navigationController?.hidesBarsOnSwipe = true

        let navBarProfileButton = UIButton()
        navBarProfileButton.addTarget(self, action: #selector(didTapNavBarProfileButton), for: .touchUpInside)
        navBarProfileButton.setImage(#imageLiteral(resourceName: "navBarProfileImg"), for: .normal)
        navBarProfileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBarProfileButton)
    }
    
    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return numOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return numberOfRowsInSection
    }

    // MARK: UI configuration

    func configureCell(_ cell: DialogCell, at indexPath: IndexPath)
    {
        let row = indexPath.row
        let section = indexPath.section

        cell.selectionStyle = .none

        if section == 0
        {
            let customCell = CustomDialogCell(lastMessageText: "Newest unreaded message", userName: "Eugene", lastMessageDate: Date(), isUserOnline: true, hasUnreadMessages: true)

            cell.backgroundColor = .CellYellowColor
            cell.userName = "User_\(row + 1)"
            switch row
            {
            case 0:
                cell.lastMessageText = customCell.lastMessageText
                cell.userName = customCell.userName
                cell.lastMessageDate = customCell.lastMessageDate
                cell.isUserOnline = customCell.isUserOnline
                cell.hasUnreadMessages = customCell.hasUnreadMessages
                break
            case 1:
                cell.lastMessageText = "2nd message"
                cell.lastMessageDate = Date().addingTimeInterval(-60 * 10)
                cell.isUserOnline = true
                cell.hasUnreadMessages = false
                break
            case 2:
                cell.lastMessageText = "3rd message"
                cell.lastMessageDate = Date().addingTimeInterval(-60 * 15)
                cell.isUserOnline = true
                cell.hasUnreadMessages = false
                break
            case 3:
                cell.lastMessageText = "long long long long unwrapped message"
                cell.lastMessageDate = Date().addingTimeInterval(-60 * 20)
                cell.isUserOnline = true
                cell.hasUnreadMessages = true
                break
            case 4:
                cell.lastMessageText = "long long long...\nmultiline message"
                cell.lastMessageDate = Date().addingTimeInterval(-60 * 60 * 24)
                cell.isUserOnline = true
                cell.hasUnreadMessages = true
                break
            case 5:
                cell.lastMessageText = "6th message"
                cell.lastMessageDate = Date().addingTimeInterval(-60 * 60 * 24)
                cell.isUserOnline = true
                cell.hasUnreadMessages = false
                break
            case 6...9:
                cell.lastMessageText = nil
                cell.lastMessageDate = nil
                cell.isUserOnline = true
                cell.hasUnreadMessages = false
                cell.lastMessageLabel.font = .appMainLightFont
                break
            default:
                break
            }
        }
        else
        {
            cell.backgroundColor = .white
            cell.userName = "User_\(row + 11)"
            cell.lastMessageText = String.randomString()
            cell.hasUnreadMessages = false
            cell.isUserOnline = false

            let timeInterval = Double(-60 * row + 1)
            cell.lastMessageDate = Date().addingTimeInterval(timeInterval)

            switch row
            {
            case 0:
                cell.hasUnreadMessages = true
                cell.lastMessageDate = Date().addingTimeInterval(-60)
                break
            case 6...9:
                cell.hasUnreadMessages = true
                break
            default:
                break
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReusabledentifier, for: indexPath) as! DialogCell

        configureCell(cell, at: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var headerTitle = "Online"

        if section == 1 { headerTitle = "History" }

        return headerTitle
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath)
        {
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
            dialogVC.navigationItem.title = cell.userName!
        }
    }
    
    //MARK: - Private properties
    
    private let cellReusabledentifier = "idDialogsCell"
    private let numOfSections = 1
    private let numberOfRowsInSection = 10
    private let idShowDialogSegue = "idShowDialogSegue"
}
