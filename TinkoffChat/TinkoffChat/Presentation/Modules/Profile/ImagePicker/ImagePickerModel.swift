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
    
    func loadImages()
}

final class ImagePickerModel: IImagePickerModel
{
    // MARK: - IImagePickerModel
    
    var imagesCount: Int
    {
        return getImagesCount()
    }
    
    func loadImages()
    {
        
    }
    
    // MARK: - Life cycle
    
    init(imageLoaderService: IImageLoaderService)
    {
        imageLoader = imageLoaderService
    }
    
    // MARK: - Private methods
    
    private func getImagesCount() -> Int
    {
        return 3
    }
    
    // MARK: - Private properties
    
    // MARK: Services
    
    private let imageLoader: IImageLoaderService
}
