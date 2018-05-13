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
    var price = Money(0)
    var about: String?
    var img: String?
    var uploaderUserName: String?
    var subcategoryID: [Int]?
    
    private struct ShoppingItemStruct: Codable
    {
        var id: Int
        var name: String
        var date_added: String
        var price: Int
        var about: String?
        var image: String?
        var item_id: Int?
        var user_name: String?
        var subcategory_id: [Int]?
    }
    
    
    // MARK: - inits
    override init()
    {
        super.init()
    }
    
    required init?(fromData data: Data)
    {
        super.init()
        
        if !self.decodeFromJSON(data)
        {
            return nil
        }
    }
    
    
    // MARK: - Factory
    static func itemsFactory(from data: Data) -> [ShoppingItem]?
    {
        let decoder = JSONDecoder()
        
        guard let newItems = try? decoder.decode([ShoppingItemStruct].self, from: data) else
        {
            return nil
        }
        
        var ans = [ShoppingItem]()
        
        for item in newItems
        {
            let newItem = ShoppingItem()
            newItem.fillFromShoppingItemStruct(item)
            ans.append(newItem)
        }
        
        return ans
    }
    
    
    // MARK: - JSON work
    func decodeFromJSON(_ data: Data) -> Bool
    {
        let decoder = JSONDecoder()
        
        guard let newItem = try? decoder.decode([ShoppingItemStruct].self, from: data) else
        {
            return false
        }
        
        self.fillFromShoppingItemStruct(newItem.last!)
        return true
    }
    
    func encodeToJSON() -> Data?        // TODO: - TODO
    {
        return nil
    }
    
    
    // MARK: - Some privates
    private func fillFromShoppingItemStruct(_ val: ShoppingItemStruct)
    {
        self.ID = val.id
        self.name = val.name
        self.about = val.about
        self.uploaderUserName = val.user_name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateAdded = formatter.date(from: val.date_added)!
        
        self.price = Money(cents: val.price)
        
        self.subcategoryID = val.subcategory_id
        
        self.img = val.image
        if self.img == "NULL" || self.img == "null" || self.img == ""
        {
            self.img = nil
        }
    }
}
