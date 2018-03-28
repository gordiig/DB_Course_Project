//
//  ShoppingItem.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 28.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class ShoppingItem: NSObject, JSONable
{
    var ID = 0
    var name = "Shopping item"
    var dateAdded = Date()
    var price = 99.99
    var imgUrls: [URL]?
    
    private struct ShoppingItemStruct: Codable
    {
        var id: Int
        var name: String
        var date_added: String
        var price: String
        var imgUrls: String?
    }
    
    
    // MARK: - inits
    override init()
    {
        super.init()
    }
    
    required init?(fromData data: Data)
    {
        super.init()
        
        
    }
    
    
    // MARK: - JSON work
    func decodeFromJSON(_ data: Data) -> Bool
    {
        <#code#>
    }
    
    func encodeToJSON() -> Data?
    {
        <#code#>
    }
}
