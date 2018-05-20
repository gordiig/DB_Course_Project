//
//  CurrentUniversities.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 20.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class CurrentUniversities
{
    static var cur = [University]()
    
    static func getUniversityByID(_ id: Int) -> University?
    {
        for un in cur
        {
            if un.ID == id
            {
                return un
            }
        }
        
        return nil
    }
    
    
}
