//
//  University.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 20.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class University: NSObject, JSONable
{
    var ID: Int = 1
    var fullName: String = "Default"
    var shortName: String = "DFLT"
    
    // MARK: - Codable struct
    private struct UniversityStruct: Codable
    {
        var id: Int
        var full_name: String
        var small_name: String
    }
    
    override init()
    {
        super.init()
    }
    
    
    // MARK: - JSONable
    required init?(fromData data: Data)
    {
        super.init()
        
        if !decodeFromJSON(data)
        {
            return nil
        }
    }
    
    func decodeFromJSON(_ data: Data) -> Bool
    {
        let decoder = JSONDecoder()
        
        guard let newUniversity = try? decoder.decode(UniversityStruct.self, from: data) else
        {
            return false
        }
        self.fillFromJSONStruct(newUniversity)
        
        return true
    }
    
    func encodeToJSON() -> Data?
    {
        return nil
    }
    
    
    // MARK: - Factory
    static func universitiesFactory(fromData data: Data) -> [University]?
    {
        let decoder = JSONDecoder()
        
        guard let newUniversities = try? decoder.decode([UniversityStruct].self, from: data) else
        {
            return nil
        }
        
        var ans = [University]()
        for un in newUniversities
        {
            let newItem = University()
            newItem.fillFromJSONStruct(un)
            ans.append(newItem)
        }
        
        return ans
    }
    
    
    // MARK: - Some privates
    private func fillFromJSONStruct(_ val: UniversityStruct)
    {
        self.ID = val.id
        self.fullName = val.full_name
        self.shortName = val.small_name
    }
}
