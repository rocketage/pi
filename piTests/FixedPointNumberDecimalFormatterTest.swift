//
//  FixedPointNumberDecimalFormatterTest.swift
//  pi
//
//  Created by Rick on 23/05/2015.
//  Copyright (c) 2015 Audiodog. All rights reserved.
//

import XCTest

class FixedPointNumberDecimalFormatterTest: XCTestCase {

    var formatter = FixedPointNumberDecimalFormatter()
    
    override func setUp()
    {
        formatter.roundup = true
        formatter.removeTrailingZeros = true
    }
    
    func testConvertIntegerToString()
    {
        let number = FixedPointNumber(integerPart: 42, decimalPlaces: 1)
        XCTAssertEqual(formatter.toString(number), "42.0")
    }

    func testConvertToOneDecimalPlace()
    {
        let number = FixedPointNumber(numerator: 1, denominator: 5, decimalPlaces: 1)
        XCTAssertEqual(formatter.toString(number), "0.2")
    }

    func testConvertToTwoDecimalPlaces()
    {
        let number = FixedPointNumber(numerator: 1, denominator: 4, decimalPlaces: 2)
        XCTAssertEqual(formatter.toString(number), "0.25")
    }

    func testConvertToThreeDecimalPlaces()
    {
        let number = FixedPointNumber(numerator: 1, denominator: 8, decimalPlaces: 3)
        XCTAssertEqual(formatter.toString(number), "0.125")
    }
    
    func testRemovesTrailingZeros()
    {
        let number = FixedPointNumber(numerator: 1, denominator: 5, decimalPlaces: 3)
        XCTAssertEqual(formatter.toString(number), "0.2")
    }

    func testKeepsTrailingZeros()
    {
        let number = FixedPointNumber(numerator: 1, denominator: 5, decimalPlaces: 3)
        formatter.removeTrailingZeros = false
        XCTAssertEqual(formatter.toString(number), "0.200")
    }

    func testRoundsUpLastDigit()
    {
        var number = FixedPointNumber(numerator: 2, denominator: 3, decimalPlaces: 10)
        XCTAssertEqual(formatter.toString(number), "0.6666666667")
    }

    func testRoundupDoesNothingWhenLastDigitIsFiveOrLess()
    {
        var a = FixedPointNumber(numerator: 1, denominator: 3, decimalPlaces: 5)
        var b = [1, 2, 3, 4, 5] as [UInt32]
        let c = [1, 2, 3, 4] as [UInt32]
        formatter.roundupDigits(&b)
        XCTAssertEqual(b, c)
    }
    
    func testRoundupCanRoundupPenultimateDigit()
    {
        var a = FixedPointNumber(numerator: 1, denominator: 3, decimalPlaces: 5)
        var b = [1, 2, 3, 4, 6] as [UInt32]
        let c = [1, 2, 3, 5] as [UInt32]
        formatter.roundupDigits(&b)
        XCTAssertEqual(b, c)
    }
    
    func testRoundupCanRoundupAllDigitsButLastWithoutOverflow()
    {
        var a = FixedPointNumber(numerator: 1, denominator: 3, decimalPlaces: 5)
        var b = [1, 9, 9, 9, 6] as [UInt32]
        let c = [2, 0, 0, 0] as [UInt32]
        let didOverflow = formatter.roundupDigits(&b)
        XCTAssertEqual(b, c)
        XCTAssertFalse(didOverflow)
    }
    
    func testRoundupCanRoundupAllDigitsWithOverflow()
    {
        var a = FixedPointNumber(numerator: 1, denominator: 3, decimalPlaces: 5)
        var b = [9, 9, 9, 9, 6] as [UInt32]
        let c = [0, 0, 0, 0] as [UInt32]
        let didOverflow = formatter.roundupDigits(&b)
        XCTAssertEqual(b, c)
        XCTAssertTrue(didOverflow)
    }
    
    func testDefeatRoundUpLastDigit()
    {
        var number = FixedPointNumber(numerator: 2, denominator: 3, decimalPlaces: 10)
        formatter.roundup = false
        XCTAssertEqual(formatter.toString(number), "0.6666666666")
    }
}
