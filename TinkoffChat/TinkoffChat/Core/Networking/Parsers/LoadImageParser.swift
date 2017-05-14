//
//  LoadImageParser.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

final class LoadImageParser: Parser<UIImage>
{
    // MARK: - Parser<UIImage>

    override func parse(response: Data) -> UIImage?
    {
        return UIImage(data: response)
    }
}
