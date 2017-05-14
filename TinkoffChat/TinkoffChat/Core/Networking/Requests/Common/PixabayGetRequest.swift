//
//  PixabayGetRequest.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IPixabayGetRequest: IRequest
{
    var path: String { get }
    var query: String { get }
}

open class PixabayGetRequest: IPixabayGetRequest
{
    // MARK: - PixabayGetRequest
    
    private(set) var path: String = ""
    private(set) var query: String = ""
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest?
    {
        let urlString = CRequest.pixabayBaseUrl + path + "?" + encodedQuery()
        var urlRequest: URLRequest?
        
        if let url = URL(string: urlString)
        {
            urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout)
        }
        return urlRequest
    }
    
    // MARK: - PixabayGetRequest
    
    internal let apiKey = "5362275-332e9f8f715d03ab4b2defb56"
    
    // MARK: - Private methods
    
    private func encodedQuery() -> String
    {
        return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    // MARK: - Private properties
    
    private let timeout = 7.0
}
