//
//  SignUpViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 13.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, Alertable
{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var submitBut: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    @IBAction func submitButPressed(_ sender: Any)
    {
        guard let username = usernameTextField.text else
        {
            showAlert(withString: "You must enter username!")
            return
        }
        if username == "" {showAlert(withString: "You must enter username!"); return}
        
        guard let password = passwordTextField.text else
        {
            showAlert(withString: "You must enter password!")
            return
        }
        if password == "" {showAlert(withString: "You must enter password!"); return}
        
        guard let city = cityTextField.text else
        {
            showAlert(withString: "You must enter your city!")
            return
        }
        if city == "" {showAlert(withString: "You must enter your city!"); return}
        
        guard let email = emailTextField.text else
        {
            showAlert(withString: "You must enter your email!")
            return
        }
        if email == "" {showAlert(withString: "You must enter your email!"); return}
        
        guard let phoneNumber = phoneTextField.text else
        {
            showAlert(withString: "You must enter your phone number!")
            return
        }
        if phoneNumber == "" {showAlert(withString: "You must enter your phone number!"); return}
        
        let firstName = firstNameTextField.text ?? "NULL"
        let lastName = lastNameTextField.text ?? "NULL"
        
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error occured while web task!:\n \(error!.localizedDescription)")
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
            if ans?.first == "["
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
            else if ans?.first == "0"
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Entered username is olready in use. Think of a different one.")
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Unknown error has occured while uploading userinfo. Please try again!")
                }
            }
            
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.signUpWebTask(username: username, firstName: firstName, lastName: lastName, password: password, phoneNumber: phoneNumber, email: email, city: city, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: {})
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
    
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
