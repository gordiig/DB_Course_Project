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
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
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
//        print("--")
//        print(base64)
//        print("--")
        let newBase64 = base64.replacingOccurrences(of: "/", with: "&")
        
        let username = user.username
        let password = user.password
        
        var finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/update_user_photo/")!
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password!)
        finalURL.appendPathComponent(newBase64)
        
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
            if ans?.first == "1"
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
        
        task.resume()
    }
    
    func webTask(username: String)
    {
        let finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/get_safe_user_info/\(username)")!
        
        let urlRequest = URLRequest(url: finalURL)
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlRequest)
        {
            (data, response, error) in
            
            if error != nil
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error with getting user info!\n \(error!.localizedDescription)")
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
            
            defer
            {
                DispatchQueue.main.async
                {
                    self.activityIndicator.stopAnimating()
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
