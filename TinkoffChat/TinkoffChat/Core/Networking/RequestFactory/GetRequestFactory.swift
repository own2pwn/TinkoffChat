//
//  GetRequestFactory.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

struct GetRequestFactory
{
    struct ImageLoaderGetRequests
    {
        static func getImagesCountRequest(for query: String, limit: Int) -> RequestConfig<ImageListApiModel>
        {
            return RequestConfig(request: GetImagesRequest(query: query, limit: limit),
                                 parser: GetImagesParser())
        }
    }
}
