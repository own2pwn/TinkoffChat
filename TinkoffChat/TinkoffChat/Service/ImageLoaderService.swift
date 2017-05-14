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
                   completion: () -> Void)
    
    func getImagesCount(for request: String,
                        completion: (Int) -> Void)
}

final class ImageLoaderService: IImageLoaderService
{
    // MARK: - IImageLoaderService
    
    func getImages(for query: String, completion: () -> Void)
    {
        
    }
    
    func getImagesCount(for request: String,
                        completion: (Int) -> Void)
    {
        
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
