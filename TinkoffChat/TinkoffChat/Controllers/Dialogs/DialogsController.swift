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

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

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
        navBarProfileButton.setImage(#imageLiteral(resourceName: "navBarProfileImg"), for: .normal)
        navBarProfileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBarProfileButton)
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
