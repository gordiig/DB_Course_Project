//
//  TmpViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 26.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class TmpViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clrButClicked(_ sender: Any)
    {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "Username")
        defaults.removeObject(forKey: "Password")
        
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else
        {
            self.showAlert(withString: "Something wrong with entering mainVC")
            return
        }
        
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    private func showAlert(withString str: String)
    {
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
