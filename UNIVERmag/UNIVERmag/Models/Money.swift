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
    private(set) var powForCents = 0
    var currencySign = "₽"
    
    override public var description: String
    {
        var ans = "\(dollars)."
        for _ in 0 ..< powForCents-1
        {
            ans += "0"
        }
        ans += "\(cents)\(currencySign)"
        
        return ans
    }
    
    init(_ dollar: Int, cents: Int = 0, powerForCents: Int = 1)
    {
        super.init()
        
        self.dollars = dollar
        self.cents = cents
        
        if powerForCents >= 1
        {
            self.powForCents = powerForCents
        }
    }
    
    init(_ money: Double)
    {
        super.init()
        
        let sep = money.integersSeparatedByPoint()
        dollars = sep.dollars
        cents = sep.cents
        powForCents = sep.powerForCents
    }
    
    func toDecimal() -> Decimal
    {
        let newFloat = Decimal(cents) / pow(10, powForCents)
        
        var ans = Decimal(abs(dollars)) + newFloat
        ans *= Decimal(abs(dollars) / dollars)
        
        return ans
    }
    
    func toDouble() -> Double
    {
        let decimal = self.toDecimal()
        let ans = (decimal as NSDecimalNumber).doubleValue
        return ans
    }
}
