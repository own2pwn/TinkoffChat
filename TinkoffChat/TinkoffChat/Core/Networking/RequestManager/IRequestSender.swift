//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IRequestSender
{
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void)
}

struct RequestConfig<T>
{
    let request: IRequest
    let parser: Parser<T>
}
