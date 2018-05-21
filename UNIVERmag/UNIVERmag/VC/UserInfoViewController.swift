//
//  TmpViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 26.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Alertable
{
    @IBOutlet weak var refreshBut: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var changePhotoBut: UIButton!
    @IBOutlet weak var editProfileBut: UIButton!
    @IBOutlet weak var logOutBut: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showAllBut: UIButton!
    var user = CurrentUser.getUser
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if user != CurrentUser.getUser
        {
            refreshBut.isEnabled = false
            changePhotoBut.isEnabled = false
            changePhotoBut.isHidden = true
            editProfileBut.isEnabled = false
            editProfileBut.isHidden = true
            logOutBut.isEnabled = false
            logOutBut.isHidden = true
            
            showAllBut.isEnabled = true
            showAllBut.isHidden = false
            
            let tmpName = user.username
            if tmpName != "Debug"
            {
                activityIndicator.startAnimating()
                webTask(username: user.username)
            }
        }
        else if user is LookingUser
        {
            refreshBut.isEnabled = false
            editProfileBut.isEnabled = false
            changePhotoBut.isEnabled = false
            logOutBut.setTitle("Log in or sign up", for: .normal)
            fillFromUser(user)
        }
        else
        {
            fillFromUser(user)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        fillFromUser(user)
    }
    
    
    // MARK: - Button pressed
    @IBAction func logOutButPressed(_ sender: Any)
    {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "Username")
        defaults.removeObject(forKey: "Password")
        CurrentUser.reset()
        
        guard let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInNavigationController") else
        {
            self.showAlert(withString: "Something wrong with entering LogInVC")
            return
        }
        
        self.present(logInVC, animated: true, completion: nil)
    }
    
    @IBAction func changeUserPhotoButPressed(_ sender: Any)
    {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showAllButPressed(_ sender: Any)
    {
        let storyboard = self.storyboard
        
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "UserItemsVC") as? UserItemsViewController else
        {
            showAlert(withString: "Error with instantiation UserItemsVC\n")
            return
        }
        destVC.user = self.user
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func refreshButPressed(_ sender: Any)
    {
        activityIndicator.startAnimating()
        refreshWebTask()
    }
    
    
    // MARK: - delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let base64 = img.base64(format: .jpeg(0.5))
        if base64 != nil
        {
            webTask(base64!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - WebTask
    func webTask(_ base64: String)
    {
        let newBase64 = base64.replacingOccurrences(of: "/", with: "&")
        
        let username = user.username
        guard let password = user.password else
        {
            showAlert(withString: "Login first!")
            return
        }
     
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
                    self.showAlert(title: "Sucsess!", withString: "Sucsessfully updated photo!")
                    self.user.img = base64
                    self.setPic(base64: base64)
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Something went wrong! Please try again!\n")
                }
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.updateUserPhotoWebTask(username: username, password: password, base64: newBase64, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: {})
    }
    
    func webTask(username: String)
    {
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error with getting user info!\n \(error!.localizedDescription)")
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
                    guard let tmpUser = User(fromData: data) else
                    {
                        self.showAlert(withString: "Error with decoding data\n")
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                    
                    self.user = tmpUser
                    self.fillFromUser(self.user)
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "No such user, or another error occured!\n")
                }
            }
        }
        
        let deferBody: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.getSafeUserInfoWebTask(username: username, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    func refreshWebTask()
    {
        let username = user.username
        
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error with getting user info!\n \(error!.localizedDescription)")
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
                    guard let tmpUser = User(fromData: data) else
                    {
                        self.showAlert(withString: "Error with decoding data\n")
                        return
                    }
                    
                    self.user.username = tmpUser.username
                    self.user.city = tmpUser.city
                    self.user.email = tmpUser.email
                    self.user.firstName = tmpUser.firstName
                    self.user.lastName = tmpUser.lastName
                    self.user.phoneNumber = tmpUser.phoneNumber
                    self.user.universityID = tmpUser.universityID
                    self.fillFromUser(self.user)
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "No such user, or another error occured!\n")
                }
            }
        }
        
        let deferBody: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.activityIndicator.stopAnimating()
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.getSafeUserInfoWebTask(username: username, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Some privates
    private func setPic(base64: String?)
    {
        guard let img = base64 else
        {
            return
        }
        guard let data = Data(base64Encoded: img) else
        {
            return
        }
        userImage.image = UIImage(data: data)
    }
    
    private func fillFromUser(_ user: User)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        usernameLabel.text = user.username
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        emailLabel.text = user.email
        phoneLabel.text = user.phoneNumber
        cityLabel.text = user.city
        if user is LookingUser
        {
            dateLabel.text = String.randomEmoji()
            universityLabel.text = String.randomEmoji()
        }
        else
        {
            dateLabel.text = formatter.string(from: user.dateOfRegistration)
            universityLabel.text = CurrentUniversities.getUniversityByID(user.universityID)?.shortName
        }
        self.setPic(base64: user.img)
    }
    
}
