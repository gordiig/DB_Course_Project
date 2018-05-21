//
//  ViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Alertable, UITextFieldDelegate
{
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var justLookingButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    // MARK: - UITextField works
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == usernameTextField
        {
            passwordTextField.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: - Loggining in (Web task)
    @IBAction func logInButClicked(_ sender: Any)
    {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if username.isEmpty || password.isEmpty
        {
            showAlert(withString: "Enter username and password!")
            return
        }
        
        // FOR NO_INTERNET_DEBUG
        if username == "noCon" && password == "noCon"
        {
            self.saveUserPassword(username: username, password: password)
            self.goToMainVC()
        }
        
        LogInButton.isEnabled = false
        getUserInfo(username: username, password: password)
    }
    
    func getUserInfo(username: String, password: String)
    {
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Can't get userinfo. Please try again!:\n \(error!.localizedDescription)")
            }
        }
        
        let dataErrorHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error in downloaded data! Please try again!\n")
            }
        }
        
        let succsessHandler: (Data, String?) -> Void =
        { (data, ans) in
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
            
        }
        
        let deferBody: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.LogInButton.isEnabled = true
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.loginTask(username: username, password: password, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    
    @IBAction func justLookingButtonPressed(_ sender: Any)
    {
        
    }
    
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Some privates
    private func goToMainVC()
    {
        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainTapBarViewController") else
        {
            self.showAlert(title: "Error", withString: "Something wrong with entering mainVC")
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

