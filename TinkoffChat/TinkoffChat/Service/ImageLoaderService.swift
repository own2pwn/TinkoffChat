//
//  ImageLoaderService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

protocol IImageLoaderService
{
    func getImages(for query: String,
                   limit: Int,
                   completion: @escaping (ImageListApiModel?) -> Void)

    func loadImage(by url: String,
                   completion: @escaping (UIImage?) -> Void)
}

final class ImageLoaderService: PixabayRequestSender, IImageLoaderService
{
    // MARK: - IImageLoaderService

    func getImages(for query: String,
                   limit: Int,
                   completion: @escaping (ImageListApiModel?) -> Void)
    {
        let getImagesRequest =
            GetRequestFactory.ImageLoaderGetRequests.getImagesCountRequest(for: query, limit: limit)

        makeRequest(requestConfig: getImagesRequest)
        { imageListModel, error in
            if let error = error
            {
                print("^ getImages error: \(error)")
            }
            completion(imageListModel)
        }
    }

    func loadImage(by url: String,
                   completion: @escaping (UIImage?) -> Void)
    {
        let loadImageRequest =
            GetRequestFactory.ImageLoaderGetRequests.loadImageRequest(by: url)

        makeRequest(requestConfig: loadImageRequest)
        { image, error in
            if let error = error
            {
                print("^ loadImage error: \(error)")
            }
            completion(image)
        }
    }
}
