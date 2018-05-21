//
//  LookingUser.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 21.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class LookingUser: User
{
    override init()
    {
        super.init()
        
        super.username = "👀"
        super.password = nil
        super.city = String.randomEmoji()
        super.email = String.randomEmoji()
        super.firstName = String.randomEmoji()
        super.lastName = String.randomEmoji()
        super.phoneNumber = String.randomEmoji()
    }
    
    
    required init?(fromData data: Data)
    {
        return nil
    }
}
