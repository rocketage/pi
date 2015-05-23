//
//  ArctanTaylorSequence.swift
//  pi
//
//  Created on 15/05/2015.
//  Copyright (c) 2015 Audiodog. All rights reserved.
//

import Foundation

struct ArctanTaylorFixedPointNumberSequence : SequenceType
{
    let denominator: UInt32
    let decimalPlaces: Int

    init(unitFractionDenominator: UInt32, decimalPlaces: Int)
    {
        denominator = unitFractionDenominator
        self.decimalPlaces = decimalPlaces
    }
    
    func generate() -> GeneratorOf<FixedPointNumber>
    {
        var index: UInt32 = 1
        var positiveSign = false;
        
        let unitFractionDenominator = denominator
        var x = FixedPointNumber(numerator: 1, denominator: denominator, decimalPlaces: decimalPlaces)
        let xDivisor = unitFractionDenominator * unitFractionDenominator
        
        return GeneratorOf<FixedPointNumber> {
            var term = FixedPointNumber(fixedPointNumber: x)
            term /= index
            
            positiveSign = !positiveSign
            index += 2
            
            x /= xDivisor
            term.isPositive = positiveSign
            
            return term.isZero() ? nil : term
        }
    }
}
