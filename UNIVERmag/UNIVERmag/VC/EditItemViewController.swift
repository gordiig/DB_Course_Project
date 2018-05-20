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
    
    @IBOutlet weak var soldSwitch: UISwitch!
    @IBOutlet weak var categoriesTableView: MenuTableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var submitBut: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var exchangeSwitch: UISwitch!
    @IBOutlet weak var universityPickerView: UniversityPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        aboutTextField.layer.cornerRadius = 5
        aboutTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        aboutTextField.layer.borderWidth = 0.5
        aboutTextField.clipsToBounds = true
        
        categoriesTableView.layer.cornerRadius = 5
        categoriesTableView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        categoriesTableView.layer.borderWidth = 0.5
        categoriesTableView.clipsToBounds = true
        
        nameTextField.delegate = self
        priceTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        soldSwitch.isOn = item.isSold
        nameTextField.text = item.name
        priceTextField.text = String(item.price.toDouble())
        aboutTextField.text = item.about ?? ""
        exchangeSwitch.isOn = item.isExchangeable
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        adjustingHeight(true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(_ show: Bool, notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        //        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        self.bottomConstraint.constant += changeInHeight
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
        let isExchangeable = exchangeSwitch.isOn ? "true" : "false"
        
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
            return
        }
        else
        {
            subcatIDs.removeLast()
        }
        
        let isSold = soldSwitch.isOn ? "Sold" : "NotSold"
        let unNum = universityPickerView.selectedRow(inComponent: 0)
        let unID = CurrentUniversities.cur[unNum].ID
        
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
        
        let succsessHandler: (Data, String?) -> Void =
        { (data, ans) in
            if ans?.first != "0"
            {
                DispatchQueue.main.async
                {
                    self.item.name = name
                    self.item.price = priceMon
                    self.item.about = self.aboutTextField.text
                    
                    self.showAlert(title: "Succsess!", withString: "Item was succsessfully updated!")
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error while updating item info!")
                }
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.editItemWebTask(itemId: itemId, name: name, price: price, about: about, subcatIDs: subcatIDs, isSold: isSold, isExchangeable: isExchangeable, unID: unID, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: {})
        
    }
    
    // MARK: - Alertable
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
