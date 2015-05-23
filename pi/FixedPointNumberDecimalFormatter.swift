//
//  FixedPointNumberDecimalFormatter.swift
//  pi
//
//  Created by Rick on 23/05/2015.
//  Copyright (c) 2015 Audiodog. All rights reserved.
//

import Foundation

class FixedPointNumberDecimalFormatter
{
    var roundup = true
    var removeTrailingZeros = true
    
    func toString(number: FixedPointNumber) -> String
    {
        var tempNumber = number.copy()
        var index = 0
        var digits = [UInt32]()
        
        while index <= tempNumber.decimalPlaces {
            tempNumber.parts[0] = 0
            tempNumber *= 10
            digits.append(tempNumber.integerPart())
            index++
        }
        
        var preRadix = number.integerPart()
        if roundupDigits(&digits) {
            preRadix++
        }
        
        removeTrailingZeros(&digits)
        
        var result = tempNumber.isPositive ? "" : "-"
        
        result += String(preRadix)
        result += "."
        
        for digit in digits {
            result += String(digit)
        }
        
        return result
    }
    
    func roundupDigits(inout digits: [UInt32]) -> Bool
    {
        if !roundup || (digits.count < 2) || (digits.last < 6) {
            digits.removeLast()
            return false
        }
        
        var index = digits.count - 2
        digits[index] = digits[index] + 1
        
        while (index > 0) && (digits[index] > 9) {
            digits[index] = 0
            digits[index - 1] = digits[index - 1] + 1
            index--
        }
        
        digits.removeLast()
        
        if digits[0] > 9 {
            // Did overflow
            digits[0] = 0
            return true
        }
        
        return false
    }
    
    func removeTrailingZeros(inout digits: [UInt32])
    {
        if removeTrailingZeros && (digits.count > 1) && (digits.last == 0) {
            digits.removeLast()
            removeTrailingZeros(&digits)
        }
    }
}
