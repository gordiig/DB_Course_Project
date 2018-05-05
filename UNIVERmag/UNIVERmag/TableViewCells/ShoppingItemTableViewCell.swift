//
//  ShoppingItemTableViewCell.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ShoppingItemTableViewCell: UITableViewCell
{
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    var imgBase64: String?
    {
        didSet
        {
            guard let img = imgBase64 else
            {
                itemImage.image = #imageLiteral(resourceName: "le_fu")
                return
            }
            
            guard let data = Data(base64Encoded: img) else
            {
                print("HEHE")
                itemImage.image = #imageLiteral(resourceName: "le_fu")
                return
            }
            
            itemImage.image = UIImage(data: data)
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
