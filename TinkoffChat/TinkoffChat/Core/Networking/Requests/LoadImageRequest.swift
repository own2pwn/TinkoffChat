//
//  LoadImageRequest.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class LoadImageRequest: IRequest
{
    // MARK: - IRequest
    
    var urlRequest: URLRequest?
    {
        var urlRequest: URLRequest?
        
        if let url = URL(string: url)
        {
            urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout)
        }
        return urlRequest
    }
    
    // MARK: - Life cycle
    
    init(_ url: String)
    {
        self.url = url
    }
    
    // MARK: - Private properties
    
    private let url: String
    
    private let timeout = 7.0
    
    private let apiKey = "5362275-332e9f8f715d03ab4b2defb56"
}
