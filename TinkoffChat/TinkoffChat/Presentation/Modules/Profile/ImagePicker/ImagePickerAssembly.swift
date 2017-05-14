//
//  ImagePickerAssembly.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class ImagePickerAssembly
{
    lazy var imagePickerModel: IImagePickerModel = {
        ImagePickerModel(imageLoaderService: self.imageLoader)
    }()

    // MARK: - Private

    // MARK: Services

    private lazy var imageLoader: IImageLoaderService = {
        ImageLoaderService(requestSender: self.requestSender)
    }()

    // MARK: Core objects

    private let requestSender: IRequestSender = RequestSender()
}
