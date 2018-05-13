//
//  WebTasker.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 07.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation

class WebTasker
{
    let baseURL = URL(string: "https://sql-handler.herokuapp.com/handler/")!
    
    
    // MARK: - Shopping Items web task
    func shoppingItemsWebTask(page: Int, search: String, minPrice: Int, maxPrice: Int, subcatIDs: String,
                              errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                              succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        var finalURL = baseURL.appendingPathComponent("get_shopping_items")
        finalURL.appendPathComponent("\(page)")
        finalURL.appendPathComponent("search")
        finalURL.appendPathComponent("\(search)")
        finalURL.appendPathComponent("price")
        finalURL.appendPathComponent("\(minPrice)")
        finalURL.appendPathComponent("\(maxPrice)")
        finalURL.appendPathComponent("categories")
        finalURL.appendPathComponent("\(subcatIDs)")
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Categories web task
    func categoriesWebTask(_ cats: String = "all",
                           errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                           succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        
        var finalURL = baseURL.appendingPathComponent("get_subcategories")
        finalURL.appendPathComponent(cats)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Login web task
    func loginTask(username: String, password: String,
                   errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                   succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        var finalURL = baseURL.appendingPathComponent("get_user_info")
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Shopping Items web task
    func userItemsWebTask(username: String,
                          errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                          succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        var finalURL = baseURL.appendingPathComponent("get_shopping_items")
        finalURL.appendPathComponent("user")
        finalURL.appendPathComponent(username)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Delete web task
    func deleteWebTask(username: String, password: String, idToDelete: Int,
                       errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                       succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        var finalURL = baseURL.appendingPathComponent("delete_shopping_item")
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password)
        finalURL.appendPathComponent("\(idToDelete)")
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Update user photo web task
    func updateUserPhotoWebTask(username: String, password: String, base64: String,
                                errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                                succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        var finalURL = baseURL.appendingPathComponent("update_user_photo")
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password)
        finalURL.appendPathComponent(base64)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Get safe user info web task
    func getSafeUserInfoWebTask(username: String,
                                errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                                succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        var finalURL = baseURL.appendingPathComponent("get_safe_user_info")
        finalURL.appendPathComponent(username)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Update user info web task
    func updateUserInfoWebTask(username: String, password: String, firstName: String, lastName: String, newPassword: String, phone: String, email: String,
                               city: String,
                               errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                               succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        let lastComponent = "\(firstName)&\(lastName)&\(newPassword)&\(phone)&\(email)&\(city)"
        var finalURL = baseURL.appendingPathComponent("update_user_info")
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password)
        finalURL.appendPathComponent(lastComponent)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Add item web task
    func addItemWebTask(username: String, password: String, name: String, price: Int, about: String, img: String,
                        errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                        succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        let lastComponent = "\(name)&\(price)&\(about)&\(img)"
        var finalURL = baseURL.appendingPathComponent("upload_item")
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password)
        finalURL.appendPathComponent(lastComponent)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Update (edit) item web task
    func editItemWebTask(itemId: Int, name: String, price: Int, about: String,
                         errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                         succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        let lastComponent = "\(name)&\(price)&\(about)"
        var finalURL = baseURL.appendingPathComponent("edit_item")
        finalURL.appendPathComponent(String(itemId))
        finalURL.appendPathComponent(lastComponent)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Sign Up web task
    func signUpWebTask(username: String, firstName: String, lastName: String, password: String, phoneNumber: String, email: String, city: String,
                       errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void,
                       succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void)
    {
        let lastComponent = "\(username)&\(firstName)&\(lastName)&\(password)&\(phoneNumber)&\(email)&\(city)"
        var finalURL = baseURL.appendingPathComponent("sign_up")
        finalURL.appendPathComponent(lastComponent)
        
        baseWebTask(finalURL, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    
    // MARK: - Main function
    func baseWebTask(_ finalURL: URL, errorHandler: @escaping (Error?) -> Void, dataErrorHandler: @escaping () -> Void, succsessHandler: @escaping (Data, String?) -> Void, deferBody: @escaping () -> Void )
    {
        let urlRequest = URLRequest(url: finalURL)
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlRequest)
        {
            (data, response, error) in
            
            if error != nil
            {
                errorHandler(error)
                print("Error in GET:\n \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else
            {
                dataErrorHandler()
                print("Error in downloaded data:\n")
                return
            }
            
            let ans = String(data: data, encoding: .utf8)
            succsessHandler(data, ans)
            
            defer
            {
                deferBody()
            }
        }
        
        task.resume()
    }

}
