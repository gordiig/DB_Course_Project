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

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
