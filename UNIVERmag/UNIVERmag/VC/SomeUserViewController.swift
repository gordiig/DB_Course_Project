//
//  SomeUserViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 29.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class SomeUserViewController: UIViewController, Alertable
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateOfRegLabel: UILabel!
    @IBOutlet weak var allItemsBut: UIButton!
    var user = User()
    var username = "username"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        usernameLabel.text = username
        webTask(username)
    }
    
    
    // MARK: - WebTask
    func webTask(_ username: String)
    {
        var finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/get_safe_user_info/")!
        finalURL.appendPathComponent(username)
        
        let urlRequest = URLRequest(url: finalURL)
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlRequest)
        {
            (data, response, error) in
            
            if error != nil
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Can't get userinfo. Please try again!:\n \(error!.localizedDescription)")
                }
                print("Error in GET:\n \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error in downloaded data! Please try again!\n")
                }
                print("Error in downloaded data:\n")
                return
            }
            
            let ans = String(data: data, encoding: .utf8)
            if ans?.first != "0"
            {
                DispatchQueue.main.async
                {
                    if !CurrentUser.getUser.decodeFromJSON(data)
                    {
                        self.showAlert(withString: "Can't set current user!\n")
                        return
                    }
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Wrong Username or Password!")
                }
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Alertable
    func showAlert(controller: UIViewController, title: String, withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
    func showAlert(title: String = "Error", withString str: String)
    {
        showAlert(controller: self, title: title, withString: str)
    }

}
