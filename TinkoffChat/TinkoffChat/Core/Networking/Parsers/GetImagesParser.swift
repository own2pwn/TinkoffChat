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
    let images: [ImageApiModel]
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
        return nil
    }
}
