//
//  Money.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class Money: NSObject
{
    var dollars: Int = 0
    var cents: Int = 0
    var currencySign = "₽"
    
    var doubleValue: Double
    {
        return self.toDouble()
    }
    
    override public var description: String
    {
        let ans = "\(dollars).\(cents)\(currencySign)"
        return ans
    }
    
    init(_ dollar: Int, cents: Int = 0)
    {
        super.init()
        
        self.dollars = dollar
        self.cents = cents
        
        self.normalize()
    }
    
    init(_ money: Double)
    {
        super.init()
        
        let sep = money.integersSeparatedByPoint()
        dollars = sep.dollars
        
        if sep.powerForCents < 1 || sep.powerForCents > 2
        {
            cents = 0
        }
        else
        {
            cents = sep.cents
        }
    }
    
    func toDouble() -> Double
    {
        let ans = Double(dollars) + Double(cents)/100
        return ans
    }
    
    func toCents() -> Int
    {
        return dollars * 100 + cents
    }
    
    func normalize()
    {
        while cents >= 100
        {
            var del = 100
            while cents / del > 10
            {
                del *= 10
            }
            
            dollars += (cents / del) * (del / 100)
            cents = cents % del
        }
    }
    
}
