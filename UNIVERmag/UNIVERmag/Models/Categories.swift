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
        
        self.name = newCategories[0].Category_Name
        for newCat in newCategories
        {
            subcategories.append(Subcategory(ID: newCat.Subcategory_ID, name: newCat.Subcategory_Name))
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
            for ansCat in ans
            {
                if ansCat.name == newCat.Category_Name
                {
                    ansCat.subcategories.append(Subcategory(ID: newCat.Subcategory_ID, name: newCat.Subcategory_Name))
                }
                else
                {
                    ans.append(Category(name: newCat.Category_Name, subcategories: [Subcategory(ID: newCat.Subcategory_ID, name: newCat.Subcategory_Name)]))
                }
            }
        }
        
        return ans
    }
}

struct JSONCategory : Codable
{
    var Subcategory_ID: Int
    var Subcategory_Name: String
    var Category_Name: String
}
