//
//  EditItemViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 12.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController, Alertable
{
    var item = ShoppingItem()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var aboutTextField: UILabel!
    @IBOutlet weak var submitBut: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
    @IBAction func submitButPressed(_ sender: Any)
    {
        
    }
    
    // MARK: - Alertable
    func showAlert(title: String, withString str: String)
    {
        <#code#>
    }

}
