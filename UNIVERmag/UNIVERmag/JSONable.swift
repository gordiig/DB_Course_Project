//
//  JSONable.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 28.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

protocol JSONable
{
    init?(fromData data: Data)
    
    func decodeFromJSON(_ data: Data) -> Bool
    func encodeToJSON() -> Data?
}
