//
//  ArctanTaylorFixedPointNumberSequenceTest.swift
//  pi
//
//  Created on 17/05/2015.
//  Copyright (c) 2015 Audiodog. All rights reserved.
//

import XCTest

class ArctanTaylorFixedPointNumberSequenceTest: XCTestCase 
{
    var sequence: ArctanTaylorFixedPointNumberSequence?
    let formatter = FixedPointNumberDecimalFormatter()
    
    override func setUp()
    {
        sequence = ArctanTaylorFixedPointNumberSequence(unitFractionDenominator: 5, decimalPlaces: 10)
    }
    
    func testFirstSequenceOfXIsPositiveX()
    {
        var generator = sequence!.generate()
        let result = generator.next()!
        XCTAssertEqual(formatter.toString(result), "0.2")
    }
    
    func testSecondSequenceOfXIsNegativeXPow3DividedBy3()
    {
        var generator = sequence!.generate()
        generator.next()
        XCTAssertEqual(formatter.toString(generator.next()!), "-0.0026666667")
    }
    
    func testThirdSequenceOfXIsPositiveXPow5DividedBy5()
    {
        var generator = sequence!.generate()
        generator.next()
        generator.next()
        XCTAssertEqual(formatter.toString(generator.next()!), "0.000064")
    }
    
    func testForthSequenceOfXIsNegativeXPow7DividedBy7()
    {
        var generator = sequence!.generate()
        generator.next()
        generator.next()
        generator.next()
        XCTAssertEqual(formatter.toString(generator.next()!), "-0.0000018286")
    }
    
    func testSequenceStopsWhenTermReachesZero()
    {
        var iterations = 0
        for term in sequence! {
            iterations++
        }
        println("Completed Fixed point arctan taylor sequence in \(iterations) iterations")
        XCTAssert((iterations > 0) && (iterations < 100))
    }
}
