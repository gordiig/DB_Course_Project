//
//  AddItemViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 12.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Alertable
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var submitBut: UIButton!
    let sendingItem = ShoppingItem()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    // MARK: - Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        guard let base64 = img.base64(format: .jpeg(0.5)) else
        {
            showAlert(withString: "Something wrong with image converting. Please, try again!")
            return
        }
        
        sendingItem.img = base64
        imageView.image = img
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Buttons
    @IBAction func submitButPressed(_ sender: Any)
    {
        guard let name = nameTextField.text else
        {
            showAlert(withString: "Enter name!")
            return
        }
        guard let price = priceTextField.text else
        {
            showAlert(withString: "Enter price!")
            return
        }
        guard let money = Money(string: price) else
        {
            showAlert(withString: "Something wrong with money!")
            return
        }
        let about = aboutTextField.text
        
        sendingItem.name = name
        sendingItem.price = money
        sendingItem.about = about
        
        submitBut.isEnabled = false
        webTask()
    }
    
    @IBAction func uploadPhotoButPressed(_ sender: Any)
    {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: - WebTask
    func webTask()
    {
        let user = CurrentUser.getUser
        let username = user.username
        let password = user.password
        
        let name = sendingItem.name
        let price = sendingItem.price
        let about = sendingItem.about ?? "NULL"
        let _img = sendingItem.img ?? "NULL"
        let img = _img.replacingOccurrences(of: "/", with: "$")
        
        var finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/upload_item/")!
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent(password!)
        let lastComponent = "\(name)&\(price.toCents())&\(about)&\(img)"
        finalURL.appendPathComponent(lastComponent)
        
        let urlRequest = URLRequest(url: finalURL)
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlRequest)
        {
            (data, response, error) in
            
            if error != nil
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error occured while sending item!:\n \(error!.localizedDescription)")
                }
                print("Error in GET:\n \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error in downloaded data!\n")
                }
                print("Error in downloaded data:\n")
                return
            }
            
            let ans = String(data: data, encoding: .utf8)
            if ans?.first != "0"
            {
                DispatchQueue.main.async
                {
                    self.showAlert(title: "Succsess!", withString: "Sucsessfully uploaded an item!")
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error while uploading!\n")
                }
            }
            
            defer
            {
                DispatchQueue.main.async
                {
                    self.submitBut.isEnabled = true
                }
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
