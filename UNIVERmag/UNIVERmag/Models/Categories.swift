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
    var ID: Int?
    var name: String
    
    init(ID: Int, name: String)
    {
        self.ID = ID
        self.name = name
    }
}

class Category: Subcategory, JSONable
{
    // MARK: - Variables
    var subcategories: [Subcategory] = [Subcategory]()
    
    var subcatIDs: [Int]
    {
        var ans = [Int]()
        for sub in subcategories
        {
            ans.append(sub.ID!)
        }
        return ans
    }
    
    
    // MARK: - inits
    init(name: String, subcategories: [Subcategory] = [Subcategory]())
    {
        super.init(ID: 0, name: name)
        
        self.ID = nil
        self.subcategories = subcategories
    }
    
    required init?(fromData data: Data)
    {
        super.init(ID: 0, name: "")
        
        ID = nil
        if self.decodeFromJSON(data)
        {
            return nil
        }
    }
    
    
    // MARK: - JSONable
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
    
    
    // MARK: - Fabric (mb delete)
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

class Categories: JSONable
{
    // MARK: - Variables and subscript
    var categories = [Category]()
    
    subscript(index: Int) -> Subcategory
    {
        return inOneLayer[index]
    }
    
    
    // MARK: - inits
    init(_ cat: [Category] = [Category]())
    {
        self.categories = cat
    }
    
    required init?(fromData data: Data)
    {
        if !decodeFromJSON(data)
        {
            return nil
        }
    }
    
    
    // MARK: - JSONable
    func decodeFromJSON(_ data: Data) -> Bool
    {
        let decoder = JSONDecoder()
        guard let newCategories = try? decoder.decode([JSONCategory].self, from: data) else
        {
            return false
        }
        
        self.categories = [Category]()
        for newCat in newCategories
        {
            var key = true
            for ansCat in self.categories
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
                self.categories.append(Category(name: newCat.category_name, subcategories: [Subcategory(ID: newCat.subcategory_id, name: newCat.subcategory_name)]))
            }
        }
        
        return true
    }
    
    func encodeToJSON() -> Data?
    {
        return nil
    }
    
    
    // MARK: - counts
    var catCount: Int
    {
        return categories.count
    }
    
    var catAndSubcatCount: Int
    {
        var ans = 0
        for cat in categories
        {
            ans += 1 + cat.subcatIDs.count
        }
        return ans
    }
    
    var subcatCount: Int
    {
        return catAndSubcatCount - catCount
    }
    
    
    // MARK: - One level array work
    var inOneLayer: [Subcategory]
    {
        var ans = [Subcategory]()
        for cat in categories
        {
            ans.append(cat as Subcategory)
            ans += cat.subcategories
        }
        return ans
    }
    
    var categoriesIndexesInOneLayer: [Int]
    {
        let oneLayer = self.inOneLayer
        var ans = [Int]()
        for i in 0 ..< oneLayer.count
        {
            if oneLayer[i].ID == nil
            {
                ans.append(i)
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
