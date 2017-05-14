//
//  GetImagesRequest.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class GetImagesRequest: PixabayGetRequest
{
    // MARK: - PixabayGetRequest
    
    override var path: String { return "" }
    
    override var query: String { return constructedQuery }
    
    // MARK: - Life cycle
    
    init(query: String,
         count: Int)
    {
        requestQuery = query
        self.count = count
        
        super.init()
    }
    
    // MARK: - Private methods
    
    private func constructQuery() -> String
    {
        return "key=\(apiKey)&q=\(requestQuery)&image_type=photo&pretty=true&per_page=\(count)"
    }
    
    // MARK: - Private properties
    
    private let requestQuery: String
    
    private let count: Int
    
    private var constructedQuery: String = ""
}
