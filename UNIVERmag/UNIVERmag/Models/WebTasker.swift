//
//  WebTasker.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 07.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class WebTasker
{
    let baseURL = URL(string: "https://sql-handler.herokuapp.com/handler/")
    
    func webTask(_ finalURL: URL, errorHandler: (Error?) -> Void, dataErrorHandler: () -> Void, succsessHandler: () -> Void, failHandler: () -> Void, deferBody: () -> Void )
    {
        
    }
}
