//
//  ImagePickerModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IImagePickerModel: class
{
    weak var delegate: IImagePickerViewController? { get set }
    
    var imagesCount: Int { get }
    
    func performFetch(_ query: String,
                      limit: Int,
                      completion: (() -> Void)?)
}

final class ImagePickerModel: IImagePickerModel
{
    // MARK: - IImagePickerModel
    
    weak var delegate: IImagePickerViewController?
    
    var imagesCount: Int
    {
        return dataSource.fetchedItemsCount
    }
    
    func performFetch(_ query: String,
                      limit: Int,
                      completion: (() -> Void)? = nil)
    {
        delegate?.setSpinnerStateEnabled(true)
        imageLoader.getImages(for: query, limit: limit)
        { imageListModel in
            if let model = imageListModel
            {
                self.dataSource = model
                self.delegate?.setSpinnerStateEnabled(false)
                self.delegate?.reloadDataSource()
            }
        }
    }
    
    // MARK: - Life cycle
    
    init(imageLoaderService: IImageLoaderService)
    {
        imageLoader = imageLoaderService
    }
    
    // MARK: - Private methods
    
    // MARK: - Private properties
    
    private lazy var dataSource: ImageListApiModel = {
        ImageListApiModel(totalItemsCount: 0, fetchedItemsCount: 0, images: [ImageApiModel]())
    }()
    
    // MARK: Services
    
    private let imageLoader: IImageLoaderService
}

extension IImagePickerModel
{
    func performFetch(_ query: String,
                      limit: Int,
                      completion: (() -> Void)? = nil)
    {
        performFetch(query, limit: limit, completion: completion)
    }
}
