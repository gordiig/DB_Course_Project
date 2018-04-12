//
//  ViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Alertable
{
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LogInButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    // MARK: - Loggining in
    @IBAction func logInButClicked(_ sender: Any)
    {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if username.isEmpty || password.isEmpty
        {
            showAlert(withString: "Enter username and password!")
            return
        }
        
        LogInButton.isEnabled = false
        getUserInfo(username: username, password: password)
    }
    
    func getUserInfo(username: String, password: String)
    {
        var finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/get_user_info/")!
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password)
        
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
                    self.saveUserPassword(username: username, password: password)
                    self.goToMainVC()
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Wrong Username or Password!")
                }
            }
            
            defer
            {
                DispatchQueue.main.async
                {
                    self.LogInButton.isEnabled = true
                }
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Alertable
    func showAlert(controller: UIViewController, title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String = "Error", withString str: String)
    {
        showAlert(controller: self, title: title, withString: str)
    }
    
    
    // MARK: - Some privates
    private func goToMainVC()
    {
        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainTapBarViewController") else
        {
            self.showAlert(controller: self, title: "Error", withString: "Something wrong with entering mainVC")
            return
        }

        self.present(mainVC, animated: true, completion: nil)
    }
    
    
    // TODO: Make safe login save
    private func saveUserPassword(username: String, password: String)
    {
        let defaults = UserDefaults.standard
        
        defaults.set(username, forKey: "Username")
        defaults.set(password, forKey: "Password")
    }
}

