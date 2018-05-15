//
//  AddItemViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 12.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Alertable, UITextFieldDelegate
{
    @IBOutlet weak var categoriesTableView: MenuTableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var submitBut: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let sendingItem = ShoppingItem()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        priceTextField.delegate = self
        
        aboutTextField.layer.cornerRadius = 5
        aboutTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        aboutTextField.layer.borderWidth = 0.5
        aboutTextField.clipsToBounds = true
        
        categoriesTableView.layer.cornerRadius = 5
        categoriesTableView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        categoriesTableView.layer.borderWidth = 0.5
        categoriesTableView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        adjustingHeight(true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(_ show: Bool, notification: NSNotification) {
        var userInfo = notification.userInfo!
        
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        //        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        self.bottomConstraint.constant += changeInHeight
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
        guard let password = user.password else
        {
            showAlert(withString: "Log in first!")
            submitBut.isEnabled = true
            return
        }
        
        let name = sendingItem.name
        let price = sendingItem.price
        let about = sendingItem.about ?? "NULL"
        let _img = sendingItem.img ?? "NULL"
        let img = _img.replacingOccurrences(of: "/", with: "$")
        
        let categoriesArr = CurrentCategories.cur
        var subcatIDs = ""
        let oneLayer = categoriesArr.inOneLayer
        let selectedSubcats = categoriesTableView.selectedSubcats
        for i in 0 ..< selectedSubcats.count
        {
            if selectedSubcats[i] && oneLayer[i].ID != nil
            {
                subcatIDs += "\(oneLayer[i].ID!),"
            }
        }
        if subcatIDs.isEmpty
        {
            showAlert(withString: "You must choose at least one category for your item!")
            submitBut.isEnabled = true
            return
        }
        else
        {
            subcatIDs.removeLast()
        }
        
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error occured while sending item!:\n \(error!.localizedDescription)")
            }
        }
        
        let dataErrorHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error in downloaded data!\n")
            }
        }
        
        let succsessHandler: (Data, String?) -> Void =
        { (data, ans) in
            if ans?.first == "1"
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
        }
        
        let deferBody: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.submitBut.isEnabled = true
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.addItemWebTask(username: username, password: password, name: name, price: price.toCents(), about: about, subcatIDs: subcatIDs, img: img, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
