//
//  Extensions.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

extension UIFont
{
    static let appMainFontMedium = UIFont(name: "HelveticaNeue-Medium", size: 17)!
    static let appMainFont = UIFont(name: "Helvetica Neue", size: 17)!
    static let appMainLightFont = UIFont(name: "HelveticaNeue-Light", size: 17)!
}

extension Date
{
    func extractTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: self)
    }

    func extractDay() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        return dateFormatter.string(from: self)
    }
}

extension NSNotification.Name
{
    static let DidFoundUser = Notification.Name("didFoundUser")
    static let DidReceiveMessage = Notification.Name("didReceiveMessage")
    static let DidLostUser = Notification.Name("didLostUser")
    static let FailedToStartBrowsingForUsers = Notification.Name("failedToStartBrowsingForUsers")
    static let FailedToStartAdvertising = Notification.Name("failedToStartAdvertising")
}

extension UIColor
{
    static func colorFromRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor
    {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    static let CellYellowColor = UIColor.init(red: 0.944989, green: 0.912527, blue: 0.518278, alpha: 0.751766)
    static let CellLightYellowColor = UIColor.init(red: 0.944989, green: 0.812527, blue: 0.518278, alpha: 0.751766)
    static let CellPowderColor = UIColor.colorFromRGB(188, 200, 241)
    static let ButtonEnabledColor = UIColor.colorFromRGB(250, 221, 86)
    static let ButtonDisabledColor = UIColor.colorFromRGB(250, 221, 86, 0.6)
}

extension String
{
    static func randomString(_ length: Int = 14) -> String
    {
        let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""

        for _ in 0..<length
        {
            let randomValue = arc4random_uniform(UInt32(alphabet.characters.count))
            randomString += "\(alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(randomValue))])"
        }

        return randomString
    }
}
