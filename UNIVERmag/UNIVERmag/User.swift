//
//  User.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 26.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject
{
    // MARK: - Vairables
    var ID = 0
    var username = "Username"
    var firstName: String?
    var lastName: String?
    var dateOfRegistration = Date()
    var password = "Password"
    var imgUrl: URL?
    var img: UIImage?
    var about: String?
    var phoneNumber = "+7 (999) 999-99-99"
    var email = "zzz@zzz.zz"
    var city = "City"
    
    // MARK: - Decodable struct
    private struct UserStruct: Codable
    {
        var id: Int
        var user_name: String
        var first_name: String?
        var last_name: String?
        var date_of_registration: String
        var password: String
        var img_url: URL?
        var about: String?
        var phone_number: String
        var email: String
        var city: String
        
        init(fromUser user: User)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            self.id = user.ID
            self.user_name = user.username
            self.first_name = user.firstName
            self.last_name = user.lastName
            self.date_of_registration = formatter.string(from: user.dateOfRegistration)
            self.password = user.password
            self.img_url = user.imgUrl
            self.about = user.about
            self.phone_number = user.phoneNumber
            self.email = user.email
            self.city = user.city
        }
    }
 
    
    // MARK: - inits
    override init()
    {
        super.init()
    }
    
    init?(fromData data: Data)
    {
        super.init()
        
        if !self.setFromData(data)
        {
            return nil
        }
    }
    
    // MARK: - JSON methods
    func setFromData(_ data: Data) -> Bool
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
    
    func encodeToJSONData() -> Data?
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
        self.ID = val.id
        self.username = val.user_name
        self.firstName = val.first_name
        self.lastName = val.last_name
        self.password = val.password
        self.imgUrl = val.img_url
        self.about = val.about
        self.phoneNumber = val.phone_number
        self.email = val.email
        self.city = val.city
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateOfRegistration = dateFormatter.date(from: val.date_of_registration)!
    }
}
