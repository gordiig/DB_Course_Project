//
//  UserOrientedTask.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 20.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

protocol UserOrientedTask: WebTask
{
    var username: String { get set }
    var password: String { get set }
}
