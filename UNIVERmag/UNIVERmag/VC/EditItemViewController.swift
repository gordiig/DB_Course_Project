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
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var submitBut: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        aboutTextField.layer.cornerRadius = 5
        aboutTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        aboutTextField.layer.borderWidth = 0.5
        aboutTextField.clipsToBounds = true
        
        nameTextField.delegate = self
        priceTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        nameTextField.text = item.name
        priceTextField.text = String(item.price.toDouble())
        aboutTextField.text = item.about ?? ""
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

    
    // MARK: - webTask
    @IBAction func submitButPressed(_ sender: Any)
    {
        webTask()
    }
    
    func webTask()
    {
        let itemId = item.ID
        
        guard let name = nameTextField.text else
        {
            showAlert(withString: "You must enter the name!")
            return
        }
        
        guard let priceText = priceTextField.text else
        {
            showAlert(withString: "You must enter the price!")
            return
        }
        guard let priceMon = Money(string: priceText) else
        {
            showAlert(withString: "Something wrong with constructing the Money object!")
            return
        }
        let price = priceMon.toCents()
        
        let about = aboutTextField.text ?? "NULL"
        
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Can't edit an item:\n \(error!.localizedDescription)")
            }
        }
        
        let dataErrorHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error in downloaded data!\n")
            }
        }
        
        let succsessHandler: (Data) -> Void =
        { (data) in
            DispatchQueue.main.async
            {
                self.item.name = name
                self.item.price = priceMon
                self.item.about = self.aboutTextField.text
                
                self.showAlert(title: "Succsess!", withString: "Item was succsessfully updated!")
            }
        }
        
        let failHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "No item with this id was found!")
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.editItemWebTask(itemId: itemId, name: name, price: price, about: about, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, failHandler: failHandler, deferBody: {})
        
    }
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
