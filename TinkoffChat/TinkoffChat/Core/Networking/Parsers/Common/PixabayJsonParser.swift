//
//  PixabayJsonParser.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class PixabayJsonParser
{
    func isValid(_ response: Data) -> Bool
    {
        guard ((try? JSONSerialization.jsonObject(with: response, options: .allowFragments))
            as? [String: Any]) != nil else
        {
            let text = String(data: response, encoding: .utf8)
            print("^ [PixabayJsonParser]: Response isn't valid json!\n\(String(describing: text))")

            return false
        }
        return true
    }

    func parse(_ response: Data) -> [String: Any]?
    {
        guard let jsonObject = serialize(response),
            let json = castToDictionary(jsonObject) else
        {
            let text = String(data: response, encoding: .utf8)
            print("^ [PixabayJsonParser]: Couldn't parse response\n\(String(describing: text))")

            return nil
        }
        return json
    }

    // MARK: - Private methods

    private func serialize(_ jsonData: Data) -> Any?
    {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) else
        {
            let text = String(data: jsonData, encoding: .utf8)
            print("^ Can't serialize json from response\n\(String(describing: text))")
            return nil
        }
        return jsonObject
    }

    private func castToDictionary(_ object: Any) -> [String: Any]?
    {
        guard let json = object as? [String: Any] else
        {
            print("^ Can't cast json object to dictionary!\nObject: \(object)")
            return nil
        }
        return json
    }
}
