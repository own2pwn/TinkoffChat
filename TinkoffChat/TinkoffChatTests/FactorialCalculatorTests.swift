//
//  FactorialCalculatorTests.swift
//  TinkoffChat
//
//  Created by Evgeniy on 26.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class FactorialCalculatorTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFactorialCalculating()
    {
        let calculator = FactorialCalculator()
        let result = calculator.calculateFactorial(3)

        XCTAssertEqual(result, 1 * 2 * 3)
    }
    
    func testFactorialForNil()
    {
        let calculator = FactorialCalculator()
        let result = calculator.calculateFactorial(0)
        
        XCTAssertEqual(result, 1)
    }
}
