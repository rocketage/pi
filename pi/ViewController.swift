//
//  ViewController.swift
//  pi
//
//  Created by Rick on 19/06/2015.
//  Copyright (c) 2015 Audiodog. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
    @IBOutlet var textView: NSTextView?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        textView!.string = "Calculating...."
        let startTime = NSDate()
        
        let calculator = PiCalculator()
        let result = calculator.calculate(10000)
  
        let finishTime = NSDate()
        let interval = finishTime.timeIntervalSinceDate(startTime)
        
        textView!.string = NSString(format:"Completed in %.4f : Result: %@", interval, result) as String
    }
}
