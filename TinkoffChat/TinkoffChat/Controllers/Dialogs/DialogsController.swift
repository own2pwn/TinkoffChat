//
//  DialogsController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

fileprivate let cellReusabledentifier = "idDialogsCell"
fileprivate let idShowDialogSegue = "idShowDialogSegue"

class DialogsController: UIViewController
{
    // MARK: - Outlets

    @IBOutlet weak var dialogsTableView: UITableView!

    // MARK: - Properties

    var tableViewDataSource: DialogsTableViewDataSource?

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
        tableViewDataSource = DialogsTableViewDataSource()
        dialogsTableView.dataSource = tableViewDataSource

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
        navBarProfileButton.setImage(#imageLiteral(resourceName: "profileImg"), for: .normal)
        navBarProfileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBarProfileButton)
    }

    // MARK: - Actions

    func didTapNavBarProfileButton(_ sender: UIButton)
    {
        if let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()
        {
            let profileVCView = profileVC.view
            let closeButton = UIButton(type: .custom)
            closeButton.frame = sender.frame
            closeButton.frame.origin.y += 16
            closeButton.setTitle("X", for: .normal)
            closeButton.setTitleColor(.blue, for: .normal)
            closeButton.addTarget(self, action: #selector(didTapCloseProfileButton), for: .touchUpInside)
            profileVCView?.addSubview(closeButton)

            /*
             // Решил в релизе оставить без NavBar'a, но если он нужен, код ниже:

             if let navBarFrame = navigationController?.navigationBar.frame
             {
                let profileVCView = profileVC.view
                let navBar = UINavigationBar(frame: navBarFrame)
                profileVCView?.addSubview(navBar)

                let navItem = UINavigationItem(title: "Профиль")

                let closeButton = UIButton(type: .custom)
                closeButton.frame = CGRect(x: 6.5, y: 2, width: 12, height: 21.5)

                closeButton.setTitle("X", for: .normal)
                closeButton.setTitleColor(.blue, for: .normal)
                closeButton.addTarget(self, action: #selector(didTapCloseProfileButton), for: .touchUpInside)

                let closeButtonItem = UIBarButtonItem(customView: closeButton)
                navItem.leftBarButtonItem = closeButtonItem
                navBar.setItems([navItem], animated: true)
            }
             */
            present(profileVC, animated: true, completion: nil)
        }
    }

    func didTapCloseProfileButton(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let cell = sender as? DialogCell, let dialogVC = segue.destination as? DialogController
        {
            dialogVC.navigationItem.title = cell.userName!
        }
    }
}

// MARK: - Extensions

// MARK: UITableViewDelegate

extension DialogsController: UITableViewDelegate
{
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
}

// MARK: Other

extension DialogsController
{
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
