//
//  GetRequestFactory.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

struct GetRequestFactory
{
    struct ImageLoaderGetRequests
    {
        static func getImagesCountRequest(for query: String, limit: Int) -> RequestConfig<ImageListApiModel>
        {
            return RequestConfig(request: GetImagesRequest(query: query, limit: limit),
                                 parser: GetImagesParser())
        }

        static func loadImageRequest(by url: String) -> RequestConfig<UIImage>
        {
            return RequestConfig(request: LoadImageRequest(url),
                                 parser: LoadImageParser())
        }
    }
}
