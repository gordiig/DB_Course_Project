//
//  Categories.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 04.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class Subcategory
{
    var ID: Int
    var name: String
    
    init(ID: Int, name: String)
    {
        self.ID = ID
        self.name = name
    }
}

class Category: JSONable
{
    var name: String = "Catname"
    var subcategories: [Subcategory] = [Subcategory]()
    
    init(name: String, subcategories: [Subcategory] = [Subcategory]())
    {
        self.name = name
        self.subcategories = subcategories
    }
    
    required init?(fromData data: Data)
    {
        if self.decodeFromJSON(data)
        {
            return nil
        }
    }
    
    func decodeFromJSON(_ data: Data) -> Bool
    {
        let decoder = JSONDecoder()
        guard let newCategories = try? decoder.decode([JSONCategory].self, from: data) else
        {
            return false
        }
        
        self.name = newCategories[0].category_name
        for newCat in newCategories
        {
            subcategories.append(Subcategory(ID: newCat.subcategory_id, name: newCat.subcategory_name))
        }
        
        return true
    }
    
    func encodeToJSON() -> Data?
    {
        return nil
    }
    
    static func categoriesFabric(fromData data: Data) -> [Category]?
    {
        let decoder = JSONDecoder()
        guard let newCategories = try? decoder.decode([JSONCategory].self, from: data) else
        {
            return nil
        }
        
        var ans = [Category]()
        for newCat in newCategories
        {
            var key = true 
            for ansCat in ans
            {
                if ansCat.name == newCat.category_name
                {
                    ansCat.subcategories.append(Subcategory(ID: newCat.subcategory_id, name: newCat.subcategory_name))
                    key = false
                    break
                }
            }
            
            if key
            {
                ans.append(Category(name: newCat.category_name, subcategories: [Subcategory(ID: newCat.subcategory_id, name: newCat.subcategory_name)]))
            }
        }
        
        return ans
    }
}

struct JSONCategory : Codable
{
    var subcategory_id: Int
    var subcategory_name: String
    var category_name: String
}
