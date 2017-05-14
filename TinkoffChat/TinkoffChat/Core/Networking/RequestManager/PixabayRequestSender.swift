//
//  PixabayRequestSender.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

open class PixabayRequestSender
{
    // MARK: - Life cycle
    
    init(requestSender: IRequestSender)
    {
        self.requestSender = requestSender
    }
    
    func makeRequest<T>(requestConfig: RequestConfig<T>,
                        completion: @escaping (T?, String?) -> Void)
    {
        requestSender.send(config: requestConfig)
        { result in
            switch result {
            case .success(let response):
                completion(response, nil)
                break
            case .fail(let error):
                completion(nil, error)
                break
            }
        }
    }
    
    // MARK: - Private properties
    
    // MARK: Core objects
    
    private let requestSender: IRequestSender
}
