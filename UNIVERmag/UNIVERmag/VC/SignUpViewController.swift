//
//  SignUpViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 13.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, Alertable, UITextFieldDelegate
{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var submitBut: UIButton!
    @IBOutlet weak var universityPickerView: UniversityPickerView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        cityTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField != phoneTextField { return true }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    // MARK: - Button press (web task)
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
