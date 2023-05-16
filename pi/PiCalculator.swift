//
//  File.swift
//  pi
//
//  Created by Rick on 19/06/2015.
//  Copyright (c) 2015 Audiodog. All rights reserved.
//

import Foundation

class PiCalculator
{
    func calculate(digits: Int) -> String
    {
        let arctan5 = self.taylorArctan(5, digits: digits)
        let arctan239 = self.taylorArctan(239, digits: digits)
        arctan5 *= 4
        arctan5 -= arctan239
        arctan5 *= 4
        
        let formatter = FixedPointNumberDecimalFormatter()
        return formatter.toString(arctan5)
    }
    
    func taylorArctan(unitFractionDenominator: UInt32, digits: Int) -> FixedPointNumber
    {
        var taylorResult = FixedPointNumber(decimalPlaces: digits)
        let sequence = ArctanTaylorFixedPointNumberSequence(unitFractionDenominator: unitFractionDenominator, decimalPlaces: digits)
        for term in sequence {
            if (term.isPositive) {
                taylorResult += term
            } else {
                taylorResult -= term
            }
        }
        return taylorResult
    }
}