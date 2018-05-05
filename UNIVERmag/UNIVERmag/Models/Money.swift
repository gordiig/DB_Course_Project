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
    var dollar: Int = 0
    var cents: Int = 0
    
    init(_ dollar: Int, cents: Int = 0)
    {
        super.init()
        
        self.dollar = dollar
        self.cents = cents
    }
    
    init(_ money: Float)
    {
        super.init()
        
        
    }
}
