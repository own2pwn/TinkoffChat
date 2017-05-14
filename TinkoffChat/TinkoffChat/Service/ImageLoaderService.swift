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
                   limit: Int,
                   completion: @escaping (ImageListApiModel?) -> Void)
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
}
