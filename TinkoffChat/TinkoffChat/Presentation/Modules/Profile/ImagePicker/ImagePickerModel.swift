//
//  ImagePickerModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IImagePickerModel
{
    var imagesCount: Int { get }
}

final class ImagePickerModel: IImagePickerModel
{
    // MARK: - IImagePickerModel

    var imagesCount: Int
    {
        return getImagesCount()
    }

    // MARK: - Private methods

    private func getImagesCount() -> Int
    {
        return 3
    }
}
