//
//  ImagePickerModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

protocol IImagePickerModel: class
{
    weak var delegate: IImagePickerViewController? { get set }
    
    var imagesCount: Int { get }
    
    func performFetch(_ query: String,
                      limit: Int,
                      completion: (() -> Void)?)
    
    func fetchImage(at index: Int,
                    completion: @escaping (UIImage?) -> Void)
}

final class ImagePickerModel: IImagePickerModel
{
    // MARK: - IImagePickerModel
    
    weak var delegate: IImagePickerViewController?
    
    var imagesCount: Int
    {
        return responseInfo.fetchedItemsCount
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
                self.responseInfo = model.info
                self.dataSource = model.images
                self.delegate?.setSpinnerStateEnabled(false)
                self.delegate?.reloadDataSource()
            }
            completion?()
        }
    }
    
    func fetchImage(at index: Int,
                    completion: @escaping (UIImage?) -> Void)
    {
        let imageUrl = dataSource[index].webformatUrl
        imageLoader.loadImage(by: imageUrl, completion: completion)
    }
    
    // MARK: - Life cycle
    
    init(imageLoaderService: IImageLoaderService)
    {
        imageLoader = imageLoaderService
    }
    
    // MARK: - Private properties
    
    private lazy var responseInfo: ImageListApiInfoModel = {
        ImageListApiInfoModel(totalItemsCount: 0, fetchedItemsCount: 0)
    }()
    
    private lazy var dataSource: [ImageApiModel] = {
        [ImageApiModel]()
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
