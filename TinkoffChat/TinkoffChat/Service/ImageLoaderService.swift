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
    func getImagesCount(for request: String,
                        completion: (Int) -> Void)
}

class ImageLoaderService: IImageLoaderService
{
    func getImagesCount(for request: String,
                        completion: (Int) -> Void)
    {

    }
}
