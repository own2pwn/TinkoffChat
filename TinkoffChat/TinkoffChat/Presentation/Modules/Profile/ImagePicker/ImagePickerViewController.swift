//
//  ImagePickerViewController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

protocol IImagePickerViewController: class
{
    func setSpinnerStateEnabled(_ enabled: Bool)

    func reloadDataSource()
}

final class ImagePickerViewController: UIViewController, IImagePickerViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    // MARK: - Outlets

    @IBOutlet weak var imagesCollectionView: UICollectionView!

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!

    // MARK: - IImagePickerViewController

    func setSpinnerStateEnabled(_ enabled: Bool)
    {
        updateUI
        {
            self.loadingSpinner.isHidden = !enabled
        }
    }

    func reloadDataSource()
    {
        invalidateCache()
        DispatchQueue.main.async
        {
            self.imagesCollectionView.reloadData()
        }
    }

    // MARK: - Life cycle

    required init?(coder aDecoder: NSCoder)
    {
        model = ImagePickerAssembly().imagePickerModel
        super.init(coder: aDecoder)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupLogic()
        model.performFetch(queryString, limit: limit)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // swiftlint:disable:next force_cast line_length
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDequeueIdentifier, for: indexPath) as! ImageCell
        cell.image = fetchImage(for: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return model.imagesCount
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

    private func setupLogic()
    {
        let dummyImageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "profileImg"))
        cachedImagesData.append(dummyImageData)
        loadingSpinner.hidesWhenStopped = true
        model.delegate = self
    }

    private func updateUI(_ block: @escaping () -> Void)
    {
        DispatchQueue.main.async
        {
            block()
        }
    }

    private func fetchImage(for indexPath: IndexPath) -> UIImage
    {
        let row = indexPath.row
        guard cachedImagesData.indices.contains(row),
            let imageData = cachedImagesData[row] else
        {
            cachedImagesData.insert(Data(), at: 55)
            return #imageLiteral(resourceName: "profileImg")
        }
        let image = UIImage(data: imageData) ?? #imageLiteral(resourceName: "profileImg")
        return image
    }

    private func invalidateCache()
    {
        let imagesCount = model.imagesCount
        cachedImagesData.removeAll()
        cachedImages.removeAll()

        cachedImagesData.reserveCapacity(imagesCount)
        cachedImages.reserveCapacity(imagesCount)
    }

    // MARK: Outlet actions

    @IBAction func didTapNavBarCloseButton(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true)
    }

    // MARK: - Private properties

    private var cachedImages = [UIImage]()

    private var cachedImagesData = [Data?]()

    private let queryString = "yellow flowers"

    private let limit = 110

    private let cellDequeueIdentifier = "imageCell"

    private let insetSize: CGFloat = 10

    private let itemsPerRow: CGFloat = 3

    private let model: IImagePickerModel
}
