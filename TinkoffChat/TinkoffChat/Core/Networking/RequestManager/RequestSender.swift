//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class RequestSender: IRequestSender
{
    // MARK: - IRequestSender
    
    func send<T>(config: RequestConfig<T>,
                 completionHandler: @escaping (Result<T>) -> Void)
    {
        guard let urlRequest = config.request.urlRequest else
        {
            completionHandler(Result.fail("Can't initialize urlRequest"))
            return
        }
        
        let task = session.dataTask(with: urlRequest)
        { data, response, error in
            if let error = error
            {
                print("^ dataTask error: \(error)")
                completionHandler(Result.fail(error.localizedDescription))
                return
            }
            guard let data = data else
            {
                completionHandler(Result.fail("Can't extract data from response!"))
                return
            }
            if let parsedModel = config.parser.parse(response: data)
            {
                completionHandler(Result.success(parsedModel))
            }
            else
            {
                completionHandler(Result.fail("Received data can't be parsed"))
            }
        }
        task.resume()
    }
    
    // MARK: - Private properties
    
    private let session = URLSession.shared
}
