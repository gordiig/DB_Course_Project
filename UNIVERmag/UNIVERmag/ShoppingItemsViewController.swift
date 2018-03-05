//
//  ShoppingItemsViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class testItem
{
    var image: UIImage?
    var title = "Title"
    var price = 420.0
}

class ShoppingItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var items = [testItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        for _ in 0 ..< 10
        {
            items.append(testItem())
        }
    }
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemTableCell") as? ShoppingItemTableViewCell else
        {
            print("Can't dequeue")
            return UITableViewCell()
        }
        
        cell.itemTitleLabel.text = "Title №\(indexPath.row + 1)"
        cell.itemPriceLabel.text = String(Float((arc4random() % 10000) / 100))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
