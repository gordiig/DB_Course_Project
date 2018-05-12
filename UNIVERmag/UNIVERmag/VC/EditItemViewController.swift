//
//  EditItemViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 12.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController, Alertable, UITextFieldDelegate
{
    var item = ShoppingItem()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var aboutTextField: UILabel!
    @IBOutlet weak var submitBut: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        priceTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        nameTextField.text = item.name
        priceTextField.text = String(describing: item.price.toDouble())
        aboutTextField.text = item.about
    }
    
    
    // Text Field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField != priceTextField { return true }
        
        var allowedStr = "0123456789."
        let text = textField.text ?? ""
        if text.contains(".")
        {
            allowedStr.removeLast()
        }
        
        let allowedCharacters = CharacterSet(charactersIn: allowedStr)
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    
    @IBAction func submitButPressed(_ sender: Any)
    {
        // TODO: - WebTask()
    }
    
    // MARK: - Alertable
    func showAlert(title: String, withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
