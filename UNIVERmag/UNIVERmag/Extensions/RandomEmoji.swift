//
//  RandomEmoji.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 21.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

extension String
{
    static func randomEmoji() -> String
    {
        let range = [UInt32](0x1F601...0x1F64F)
        let ascii = range[Int(drand48() * (Double(range.count)))]
        let emoji = UnicodeScalar(ascii)?.description
        return emoji!
    }
}
