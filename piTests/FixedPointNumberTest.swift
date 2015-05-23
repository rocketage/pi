//
//  BigNumberTest.swift
//  pi
//
//  Created on 16/05/2015.
//  Copyright (c) 2015 Audiodog. All rights reserved.
//

import XCTest

class FixedPointNumberTest: XCTestCase
{
    let oneHalfBinaryFraction: UInt32       = 0b10000000000000000000000000000000
    let oneQuarterBinaryFraction: UInt32    = 0b01000000000000000000000000000000
    let oneEighthBinaryFraction: UInt32     = 0b00100000000000000000000000000000
    let oneSixteenthBinaryFraction: UInt32  = 0b00010000000000000000000000000000
    
    func testCreateWithDecimalPlaces()
    {
        let decimalPlaces = 42
        let number = FixedPointNumber(decimalPlaces: decimalPlaces)
        XCTAssertEqual(number.decimalPlaces, decimalPlaces)
    }

    func testAssignIntegerPart()
    {
        let number = FixedPointNumber(integerPart: 42, decimalPlaces: 123)
        XCTAssertEqual(number.integerPart(), 42)
    }
    
    func testPartsForFractionPartCreated()
    {
        let number = FixedPointNumber(integerPart: 42, decimalPlaces: 10)
        XCTAssertGreaterThanOrEqual(number.parts.count, 3)
    }
    
    func testOneDividedByEightStoredAsBinaryFraction()
    {
        var number = FixedPointNumber(integerPart: 1, decimalPlaces: 10)
        number /= 8
        XCTAssertEqual(number.parts[1], oneEighthBinaryFraction)
    }
    
    func testThreeDividedByFourStoredAsBinaryFraction()
    {
        var number = FixedPointNumber(integerPart: 3, decimalPlaces: 10)
        number /= 4
        XCTAssertEqual(number.parts[1], oneHalfBinaryFraction | oneQuarterBinaryFraction)
    }
    
    func testOneHalfDividedByTwoIsOneQuarter()
    {
        var number = FixedPointNumber(integerPart: 1, decimalPlaces: 10)
        number /= 2
        XCTAssertEqual(number.parts[1], oneHalfBinaryFraction)
        
        number /= 2
        XCTAssertEqual(number.parts[1], oneQuarterBinaryFraction)
    }
    
    func testCreateNumberAsFraction()
    {
        let a = FixedPointNumber(numerator: 1, denominator: 16, decimalPlaces: 20)
        XCTAssertEqual(a.parts[1], oneSixteenthBinaryFraction)
        
        let b = FixedPointNumber(numerator: 7, denominator: 8, decimalPlaces: 20)
        XCTAssertEqual(b.parts[1], oneHalfBinaryFraction | oneQuarterBinaryFraction | oneEighthBinaryFraction)
    }
    
    func testIntegerMultipliedByInteger()
    {
        var number = FixedPointNumber(integerPart: 1, decimalPlaces: 10)
        number *= 10
        XCTAssertEqual(number.integerPart(), 10)
        
        number *= 6
        XCTAssertEqual(number.integerPart(), 60)
    }
    
    func testFractionMultipliedByInteger()
    {
        var number = FixedPointNumber(numerator: 1, denominator: 8, decimalPlaces: 20)
        number *= 4
        XCTAssertEqual(number.parts[1], oneHalfBinaryFraction)
    }
    
    func testFractionMultipliedByIntegerBackToInteger()
    {
        var number = FixedPointNumber(numerator: 1, denominator: 8, decimalPlaces: 20)
        number *= 16
        XCTAssertEqual(number.integerPart(), 2)
    }
    
    func testFractionAddition()
    {
        var a = FixedPointNumber(numerator: 1, denominator: 16, decimalPlaces: 20)
        let b = FixedPointNumber(numerator: 1, denominator: 4, decimalPlaces: 20)
        a += b
        XCTAssertEqual(a.parts[1], oneQuarterBinaryFraction | oneSixteenthBinaryFraction)
    }
    
    func testFractionAndIntegerAddition()
    {
        var a = FixedPointNumber(numerator: 7, denominator: 4, decimalPlaces: 20)
        let b = FixedPointNumber(numerator: 15, denominator: 8, decimalPlaces: 20)
        a += b // 7/4 + 15/8 = 14/8 + 15/8 = 29/8 = 3 and 5/8
        XCTAssertEqual(a.integerPart(), 3)
        XCTAssertEqual(a.parts[1], oneHalfBinaryFraction | oneEighthBinaryFraction)
    }
    
    func testFractionSubtraction()
    {
        var a = FixedPointNumber(numerator: 1, denominator: 2, decimalPlaces: 20)
        let b = FixedPointNumber(numerator: 1, denominator: 4, decimalPlaces: 20)
        a -= b
        XCTAssertEqual(a.parts[1], oneQuarterBinaryFraction)
    }
    
    func testFractionAndIntegerSubtraction()
    {
        var a = FixedPointNumber(numerator: 13, denominator: 4, decimalPlaces: 20)
        let b = FixedPointNumber(numerator: 3, denominator: 2, decimalPlaces: 20)
        a -= b // 13/4 - 3/2 = 13/4 - 6/4 = 7/4 = 1 3/4
        XCTAssertEqual(a.integerPart(), 1)
        XCTAssertEqual(a.parts[1], oneHalfBinaryFraction | oneQuarterBinaryFraction)
    }
    
    func testNegativeFlag()
    {
        var a = FixedPointNumber(numerator: 13, denominator: 4, decimalPlaces: 20)
        XCTAssertTrue(a.isPositive)
        a.isPositive = false;
        XCTAssertFalse(a.isPositive)
    }
    
    func testCopy()
    {
        let a = FixedPointNumber(numerator: 3, denominator: 2, decimalPlaces: 10)
        let b = a.copy()
        XCTAssertEqual(b.integerPart(), 1)
        XCTAssertEqual(b.parts[1], oneHalfBinaryFraction)
    }

    func testCopyIsIdenpendantToSource()
    {
        var a = FixedPointNumber(numerator: 3, denominator: 2, decimalPlaces: 10)
        let b = a.copy()
        a *= 10
        XCTAssertEqual(b.integerPart(), 1)
        XCTAssertEqual(b.parts[1], oneHalfBinaryFraction)
    }
}
