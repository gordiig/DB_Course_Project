//
//  EditUserInfoViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 27.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController, Alertable, UITextFieldDelegate
{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        cityTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let user = CurrentUser.getUser
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        emailTextField.text = user.email
        phoneTextField.text = user.phoneNumber
        cityTextField.text = user.city
        passwordTextField.text = user.password
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        adjustingHeight(true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(_ show: Bool, notification: NSNotification) {
        var userInfo = notification.userInfo!
        
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        //        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        self.bottomConstraint.constant += changeInHeight
    }
    
    
    // MARK: - Button press (Web task)
    @IBAction func submitButPressed(_ sender: Any)
    {
        let user = CurrentUser.getUser
        let username = user.username
        guard let password = user.password else
        {
            showAlert(withString: "Log in first!")
            return
        }
        
        let firstName = (firstNameTextField.text ?? user.firstName) ?? "NULL"
        let lastName = (lastNameTextField.text ?? user.lastName) ?? "NULL"
        let newPassword = passwordTextField.text ?? password
        let phone = phoneTextField.text ?? user.phoneNumber
        let email = emailTextField.text ?? user.email
        let city = cityTextField.text ?? user.city
        
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Can't update! Please try again!:\n \(error!.localizedDescription)")
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
        }
        
        let deferBody: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.submitButton.isEnabled = true
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.updateUserInfoWebTask(username: username, password: password, firstName: firstName, lastName: lastName, newPassword: newPassword, phone: phone, email: email, city: city, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
