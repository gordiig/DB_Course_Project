//
//  User.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 26.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject, JSONable
{
    // MARK: - Vairables
    var username = "Username"
    var firstName: String?
    var lastName: String?
    var dateOfRegistration = Date()
    var password: String?
    var phoneNumber = "+7 (999) 999-99-99"
    var email = "zzz@zzz.zz"
    var city = "City"
    var img: String?
    var universityID: Int = 1
    
    // MARK: - Decodable struct
    private struct UserStruct: Codable
    {
        var user_name: String
        var first_name: String?
        var last_name: String?
        var date_of_registration: String
        var password: String?
        var image: String?
        var phone_number: String
        var email: String
        var city: String
        var university_id: Int
        
        init(fromUser user: User)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            self.user_name = user.username
            self.first_name = user.firstName
            self.last_name = user.lastName
            self.date_of_registration = formatter.string(from: user.dateOfRegistration)
            self.password = user.password
            self.image = user.img
            self.phone_number = user.phoneNumber
            self.email = user.email
            self.city = user.city
            self.university_id = user.universityID
        }
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
    
    // MARK: - JSON methods
    func decodeFromJSON(_ data: Data) -> Bool
    {
        let decoder = JSONDecoder()
        
        let newUser = try? decoder.decode([UserStruct].self, from: data)
        let newUser2 = try? decoder.decode(UserStruct.self, from: data)
        
        if newUser2 == nil && newUser == nil
        {
            print("Cand'decode data to newUser!")
            return false
        }
        else if newUser2 == nil
        {
            self.fillFromUserStruct(userStruct: newUser!.last!)
            return true
        }
        else if newUser == nil
        {
            self.fillFromUserStruct(userStruct: newUser2!)
            return true
        }
        
        print("func setFromData(_ data: Data) -> Bool in User. I shouldn't be here!!!")
        return false
    }
    
    func encodeToJSON() -> Data?
    {
        let encodableUser = UserStruct(fromUser: self)
        let encoder = JSONEncoder()
        
        do
        {
            let data = try encoder.encode(encodableUser)
            return data
        }
        catch
        {
            return nil
        }
    }
    
    
    // MARK: - Some privates
    private func fillFromUserStruct(userStruct val: UserStruct)
    {
        self.username = val.user_name
        self.firstName = val.first_name
        self.lastName = val.last_name
        self.password = val.password
        self.img = val.image
        self.phoneNumber = val.phone_number
        self.email = val.email
        self.city = val.city
        self.universityID = val.university_id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateOfRegistration = dateFormatter.date(from: val.date_of_registration)!
    }
    
    
    // MARK: - operators
    static func == (lhs: User, rhs: User) -> Bool
    {
        if (lhs.username == rhs.username) && (lhs.firstName == rhs.firstName) && (lhs.lastName == rhs.lastName) &&
            (lhs.password == rhs.password) && (lhs.img == rhs.img) && (lhs.phoneNumber == rhs.phoneNumber) &&
            (lhs.email == rhs.email) && (lhs.city == rhs.city)
        {
            return true
        }
        
        return false
    }
    
    static func != (lhs: User, rhs: User) -> Bool
    {
        return !(lhs == rhs)
    }
}
