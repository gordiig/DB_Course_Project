//
//  TmpViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 26.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController
{
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var user = CurrentUser.getUser
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
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
        
        guard let img = user.img else
        {
            return
        }
        guard let data = Data(base64Encoded: img) else
        {
            return
        }
        userImage.image = UIImage(data: data)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    private func showAlert(withString str: String)
    {
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
