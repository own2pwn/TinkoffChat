//
//  IMPCWorker.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IMPCWorker: class
{
    func send(message: String, to userID: String, completion: (Error?) -> Void)

    var online: Bool { get set }
    weak var delegate: IMPCServiceDelegate? { get set }
}
