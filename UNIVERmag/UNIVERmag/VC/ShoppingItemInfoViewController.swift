//
//  ShoppingItemInfoViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 06.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ShoppingItemInfoViewController: UIViewController, Alertable
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var uploaderBut: UIButton!
    @IBOutlet weak var editBut: UIBarButtonItem!
    @IBOutlet weak var callBut: UIButton!
    
    var item = ShoppingItem()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = item.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        
        dateLabel.text = formatter.string(from: item.dateAdded)
        aboutLabel.text = item.about
        priceLabel.text = String(describing: item.price)
        
        editBut.isEnabled = (item.uploaderUserName == CurrentUser.getUser.username) ? true : false
        uploaderBut.setTitle(item.uploaderUserName ?? "Debug", for: .normal)
        
        let phoneNum = item.phoneNumber ?? "None"
        callBut.titleLabel?.lineBreakMode = .byWordWrapping
        callBut.titleLabel?.textAlignment = .center
        callBut.setTitle("Call\n\(phoneNum)", for: .normal)
        
        guard let img = item.img else
        {
            imageView.image = #imageLiteral(resourceName: "le_fu")
            return
        }
        guard let data = Data(base64Encoded: img) else
        {
            imageView.image = #imageLiteral(resourceName: "le_fu")
            return
        }
        imageView.image = UIImage(data: data)
    }

    
    @IBAction func userButPressed(_ sender: Any)
    {
        let storyboard = self.storyboard
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as? UserInfoViewController else
        {
            print("Err")
            return
        }
        destVC.user = User()
        destVC.user.username = (uploaderBut.titleLabel?.text)!
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func callButPressed(_ sender: Any)
    {
        let phoneNumber = item.phoneNumber ?? "None"
        guard let url = URL(string: "tel://\(phoneNumber)") else
        {
            showAlert(withString: "Something wrong with phone number, call from phone app.")
            return
        }
        
        if UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            showAlert(withString: "Something wrong with phone number, call from phone app.")
            return
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "EditItemSegue"
        {
            if let destVC = segue.destination as? EditItemViewController
            {
                destVC.item = self.item
            }
            else
            {
                self.showAlert(withString: "Something wrong with segue!")
            }
        }
    }
    
    
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
