//
//  DoubleToIntegers.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

extension Double
{
    func integersSeparatedByPoint() -> (dollars: Int, cents: Int, powerForCents: Int)
    {
        let str = "\(self)"
        let separated = str.split(separator: ".")
        
        var negativePower = 1
        for number in separated[1]
        {
            if number == "0"
            {
                negativePower += 1
            }
            else
            {
                break
            }
        }
        
        let ans = (Int(separated[0])!, Int(separated[1])!, negativePower)
        return ans
    }
}
