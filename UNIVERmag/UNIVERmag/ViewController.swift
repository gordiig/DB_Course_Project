//
//  ViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
            let alert = UIAlertController(title: "Error", message: "Enter username and password!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        checkLogIn(username: username, password: password)
    }
    
    private func checkLogIn(username: String, password: String)
    {
        var finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/loginconfirm/")!
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
                    self.showAlert(withString: "Error in GET:\n \(error!.localizedDescription)")
                }
                print("Error in GET:\n \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error in downloaded data:\n")
                }
                print("Error in downloaded data:\n")
                return
            }
            
            let ans = String(data: data, encoding: .utf8)
            if ans == "1"
            {
                DispatchQueue.main.async
                {
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
        }
        
        task.resume()
    }
    
    // MARK: - Some privates
    private func showAlert(withString str: String)
    {
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func goToMainVC()
    {
        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainTapBarViewController") else
        {
            self.showAlert(withString: "Something wrong with entering mainVC")
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

