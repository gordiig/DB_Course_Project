//
//  EditUserInfoViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 27.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController, Alertable
{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let user = CurrentUser.getUser
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        emailTextField.text = user.email
        phoneTextField.text = user.phoneNumber
        cityTextField.text = user.city
        passwordTextField.text = user.password
    }
    
    
    // MARK: - Button press
    @IBAction func submitButPressed(_ sender: Any)
    {
        let user = CurrentUser.getUser
        let username = user.username
        let password = user.password
        
        let firstName = (firstNameTextField.text ?? user.firstName) ?? "NULL"
        let lastName = (lastNameTextField.text ?? user.lastName) ?? "NULL"
        let newPassword = passwordTextField.text ?? user.password!
        let phone = phoneTextField.text ?? user.phoneNumber
        let email = emailTextField.text ?? user.email
        let city = cityTextField.text ?? user.city
        
        var finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/update_user_info/")!
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password!)
        var lastComponent = "\(firstName)&\(lastName)&\(newPassword)&\(phone)&\(email)&\(city)"
        finalURL.appendPathComponent(lastComponent)
        
        let urlRequest = URLRequest(url: finalURL)
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlRequest)
        {
            (data, response, error) in
            
            if error != nil
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Can't update! Please try again!:\n \(error!.localizedDescription)")
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
                    user.firstName = firstName
                    user.lastName = lastName
                    user.city = city
                    user.email = email
                    user.phoneNumber = phone
                    user.password = newPassword
                    
                    let defaults = UserDefaults.standard
                    defaults.set(newPassword, forKey: "Password")
                    
                    self.showAlert(title: "Sucsess", withString: "Sucsessfully updated profile!")
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error occured while updating user info\n")
                }
            }
            
            defer
            {
                DispatchQueue.main.async
                {
                    self.submitButton.isEnabled = true
                }
            }
        }
        
        submitButton.isEnabled = false
        task.resume()
    }
    
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
