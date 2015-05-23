//
//  FixedPointNumber.swift
//  pi
//
//  Created on 16/05/2015.
//  Copyright (c) 2015 Audiodog. All rights reserved.
//

import Foundation

class FixedPointNumber
{
    let decimalPlaces: Int
    var parts: [UInt32]
    var isPositive = true
    var roundup = true
    
    init(integerPart: UInt32, decimalPlaces: Int)
    {
        let partsForDigits = Int(ceil(Double(decimalPlaces) * 0.104)) + 2
        parts = [UInt32](count: partsForDigits, repeatedValue: 0)
        parts[0] = integerPart
        self.decimalPlaces = decimalPlaces
    }

    convenience init(decimalPlaces: Int)
    {
        self.init(integerPart: 0, decimalPlaces: decimalPlaces)
    }
    
    convenience init(fixedPointNumber: FixedPointNumber)
    {
        self.init(integerPart: 0, decimalPlaces: fixedPointNumber.decimalPlaces)
        for index in 0..<fixedPointNumber.parts.count {
            self.parts[index] = fixedPointNumber.parts[index]
        }
        self.isPositive = fixedPointNumber.isPositive
    }
    
    convenience init(numerator: UInt32, denominator: UInt32, decimalPlaces: Int)
    {
        self.init(integerPart: numerator, decimalPlaces: decimalPlaces)
        self /= denominator
    }
    
    func copy() -> FixedPointNumber
    {
        return FixedPointNumber(fixedPointNumber: self)
    }
    
    func integerPart() -> UInt32
    {
        return parts[0]
    }
    
    func isZero() -> Bool
    {
        for value in parts {
            if value != 0 {
                return false
            }
        }
        return true
    }
    
    func rightmostNonZeroPartIndex() -> Int
    {
        var index = 0
        while (index < parts.count) && (parts[index] == 0) {
            index++
        }
        return index
    }
    
    func leftmostNonZeroPartIndex() -> Int
    {
        var index = parts.count - 1;
        while (index >= 0) && (parts[index] == 0) {
            index--
        }
        return index
    }
}

func *= (number: FixedPointNumber, multiplier: UInt32)
{
    var index = number.leftmostNonZeroPartIndex()
    var carry: UInt32 = 0
    
    while index >= 0 {
        let result64 = (UInt64(number.parts[index]) * UInt64(multiplier)) + UInt64(carry)
        let result32 = UInt32(result64 & 0xFFFFFFFF)
        number.parts[index] = result32
        carry = UInt32(result64 >> 32)
        index--
    }
}

func /= (number: FixedPointNumber, divisor: UInt32)
{
    assert(divisor > 0, "Cannot divide by zero")
    
    var index = number.rightmostNonZeroPartIndex()
    var carry64: UInt64 = 0
    let divisor64 = UInt64(divisor)
    
    while index < number.parts.count {
        let value64 = UInt64(number.parts[index]) + (carry64 << 32)
        number.parts[index] = UInt32(value64 / divisor64)
        carry64 = (value64 % divisor64) & 0xFFFFFFFF
        index++
    }
}

func += (a: FixedPointNumber, b: FixedPointNumber)
{
    var index = b.leftmostNonZeroPartIndex()
    var carry: UInt64  = 0;
    
    while index >= 0 {
        let result = UInt64(a.parts[index]) + UInt64(b.parts[index]) + carry
        a.parts[index] = UInt32(result & 0xFFFFFFFF)
        carry = (result >= 0x100000000) ? 1 : 0
        index--
    }
}

func -= (a: FixedPointNumber, b: FixedPointNumber)
{
    var index = b.leftmostNonZeroPartIndex()
    var borrow: UInt64 = 0

    while (index >= 0) {
        let result = 0x100000000 + UInt64(a.parts[index]) - UInt64(b.parts[index]) - borrow
        a.parts[index] = UInt32(result & 0xFFFFFFFF)
        borrow = (result >= 0x100000000) ? 0 : 1
        index--
    }
}