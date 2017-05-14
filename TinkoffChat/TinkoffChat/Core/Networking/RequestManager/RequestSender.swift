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
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void)
    {
        guard let urlRequest = config.request.urlRequest else
        {
            completionHandler(Result.fail("Can't initialize urlRequest"))
            return
        }
    }
}
