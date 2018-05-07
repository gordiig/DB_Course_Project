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
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
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
        else
        {
            fillFromUser(user)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button pressed
    @IBAction func logOutButPressed(_ sender: Any)
    {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "Username")
        defaults.removeObject(forKey: "Password")
        
        guard let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") else
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
        
        let succsessHandler: (Data) -> Void =
        { (data) in
            DispatchQueue.main.async
            {
                self.showAlert(title: "Sucsess!", withString: "Sucsessfully updated photo!")
                self.user.img = base64
                self.setPic(base64: base64)
            }
        }
        
        let failHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Something went wrong! Please try again!\n")
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.updateUserPhotoWebTask(username: username, password: password, base64: newBase64, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, failHandler: failHandler, deferBody: {})
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
        
        let succsessHandler: (Data) -> Void =
        { (data) in
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
        
        let failHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "No such user, or another error occured!\n")
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
        tasker.getSafeUserInfoWebTask(username: username, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, failHandler: failHandler, deferBody: deferBody)
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
        dateLabel.text = formatter.string(from: user.dateOfRegistration)
        
        self.setPic(base64: user.img)
    }
    
}
