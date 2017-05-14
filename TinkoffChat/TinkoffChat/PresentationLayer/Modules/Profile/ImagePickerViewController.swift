//
//  ImagePickerViewController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

final class ImagePickerViewController: UIViewController
{
    // MARK: - Life cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    // MARK: - Private methods

    // MARK: Outlet actions

    @IBAction func didTapNavBarCloseButton(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true)
    }
}
