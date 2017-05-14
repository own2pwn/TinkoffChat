//
//  GetImagesParser.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

struct ImageListApiModel
{
    let info: ImageListApiInfoModel
    let images: [ImageApiModel]
}

struct ImageListApiInfoModel
{
    let totalItemsCount: Int
    let fetchedItemsCount: Int
}

struct ImageApiModel
{
    let webformatUrl: String
}

final class GetImagesParser: Parser<ImageListApiModel>
{
    // MARK: - Parser<ImageListApiModel>

    override func parse(response: Data) -> ImageListApiModel?
    {
        guard let json = jsonParser.parse(response) else
        {
            print("^ [GetImagesParser] can't parse api response!")
            return nil
        }
        if let totalItemsCount = json["total"] as? Int,
            let hits = json["hits"] as? [[String: Any]]
        {
            var images = [ImageApiModel]()
            for hit in hits
            {
                if let webformatUrl = hit["webformatURL"] as? String
                {
                    let image = ImageApiModel(webformatUrl: webformatUrl)
                    images.append(image)
                }
            }
            let info = ImageListApiInfoModel(totalItemsCount: totalItemsCount,
                                             fetchedItemsCount: images.count)

            return ImageListApiModel(info: info,
                                     images: images)
        }
        return nil
    }

    // MARK: - Private properties

    private let jsonParser = PixabayJsonParser()
}
