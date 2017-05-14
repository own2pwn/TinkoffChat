//
//  ImagePickerViewController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

final class ImagePickerViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    // MARK: - Outlets

    @IBOutlet weak var imagesCollectionView: UICollectionView!

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!

    // MARK: - Life cycle

    required init?(coder aDecoder: NSCoder)
    {
        model = ImagePickerAssembly().imagePickerModel
        super.init(coder: aDecoder)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        loadingSpinner.startAnimating()
        model.loadImages()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // swiftlint:disable:next force_cast line_length
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDequeueIdentifier, for: indexPath) as! ImageCell

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding = insetSize * (itemsPerRow + 1)
        let remainingSpace = view.frame.width - padding
        let itemSize = remainingSpace / itemsPerRow

        return CGSize(width: itemSize, height: itemSize)
    }

    // MARK: - Private methods

    // MARK: Outlet actions

    @IBAction func didTapNavBarCloseButton(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true)
    }

    // MARK: - Private properties

    private let cellDequeueIdentifier = "imageCell"

    private let insetSize: CGFloat = 10

    private let itemsPerRow: CGFloat = 3

    private let model: IImagePickerModel
}
