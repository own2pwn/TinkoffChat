//
//  ImageCell.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

protocol ImageCellModel: class
{
    var image: UIImage { get set }
}

class ImageCell: UICollectionViewCell, ImageCellModel
{
    // MARK: - Outlets

    @IBOutlet weak var imageView: UIImageView!

    // MARK: - ImageCellModel

    var image: UIImage
    {
        get
        {
            guard imageView != nil else { return #imageLiteral(resourceName: "profileImg") }
            return imageView.image!
        }
        set
        {
            guard imageView != nil else { return }
            imageView.image = newValue
        }
    }
}
