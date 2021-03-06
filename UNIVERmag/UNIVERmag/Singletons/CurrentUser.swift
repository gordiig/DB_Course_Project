//
//  Users.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 26.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class CurrentUser
{
    private(set) static var getUser: User = User()
    
    static func reset()
    {
        getUser = User()
    }
    
    static func makeJustLooking()
    {
        getUser = LookingUser()
    }
}
