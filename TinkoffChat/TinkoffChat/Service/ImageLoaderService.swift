//
//  ImageLoaderService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IImageLoaderService
{
    func getImages(for query: String,
                   count: Int,
                   completion: (ImageListApiModel?) -> Void)
}

final class ImageLoaderService: IImageLoaderService
{
    // MARK: - IImageLoaderService
    
    func getImages(for query: String,
                   count: Int,
                   completion: (ImageListApiModel?) -> Void)
    {
        let getImagesRequest =
        GetRequestFactory.ImageLoaderGetRequests.getImagesCountRequest()
    }
    
    // MARK: - Life cycle
    
    init(requestSender: IRequestSender)
    {
        self.requestSender = requestSender
    }
    
    // MARK: - Private properties
    
    // MARK: Core objects
    
    private let requestSender: IRequestSender
}
