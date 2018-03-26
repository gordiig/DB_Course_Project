//
//  WebTask.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 20.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

protocol WebTask
{
    var baseURL: URL { get }
    var finalURL: URL { get set }
    
    func perform() -> Data?
}

// For default baseURL value
extension WebTask
{
    var baseURL: URL
    {
        return URL(string: "https://sql-handler.herokuapp.com/handler/")!
    }
}
