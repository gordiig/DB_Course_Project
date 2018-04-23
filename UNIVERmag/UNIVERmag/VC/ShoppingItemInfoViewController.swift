//
//  ShoppingItemInfoViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 06.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ShoppingItemInfoViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var item = ShoppingItem()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = item.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        
        dateLabel.text = formatter.string(from: item.dateAdded)
        aboutLabel.text = item.about
        priceLabel.text = String(describing: item.price) + "₽"
        
        guard let img = item.img else
        {
            return
        }
        guard let data = Data(base64Encoded: img) else
        {
            return
        }
        imageView.image = UIImage(data: data)
    }

}
