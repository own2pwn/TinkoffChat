//
//  FactorialCalculator.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

class FactorialCalculator
{
    func calculateFactorial(_ number: UInt) -> UInt
    {
        guard number != 0 else { return 1 }

        var result: UInt = 1

        for i in 1...number
        {
            result *= i
        }

        return result
    }
}
