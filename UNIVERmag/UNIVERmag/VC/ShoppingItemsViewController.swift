//
//  ShoppingItemsViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ShoppingItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Alertable
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var items = [ShoppingItem]()
    private let itemsPerPage: Int = 20
    private var nextItemNumForWebTask = 19
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        self.webTask(page: 1)
    }
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if ((indexPath.row+1) % itemsPerPage == 0) && (indexPath.row == nextItemNumForWebTask)
        {
            nextItemNumForWebTask += itemsPerPage
            webTask(page: ((indexPath.row+1) / itemsPerPage) + 1)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemTableCell") as? ShoppingItemTableViewCell else
        {
            print("Can't dequeue")
            return UITableViewCell()
        }
        
        cell.itemTitleLabel.text = items[indexPath.row].name
        cell.itemPriceLabel.text = String(describing: items[indexPath.row].price)
        cell.imgBase64 = items[indexPath.row].img
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
    
    
    // MARK: - Web task
    func webTask(page: Int)
    {
        let finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/get_shopping_items/\(page)/")!
        let urlRequest = URLRequest(url: finalURL)
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlRequest)
        {
            (data, response, error) in
            
            if error != nil
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Can't get userinfo. Please try again!:\n \(error!.localizedDescription)")
                }
                print("Error in GET:\n \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error in downloaded data! Please try again!\n")
                }
                print("Error in downloaded data:\n")
                return
            }
            
            let ans = String(data: data, encoding: .utf8)
            if ans?.first != "0"
            {
                DispatchQueue.main.async
                {
                    guard let tmpItems = ShoppingItem.itemsFactory(from: data) else
                    {
                        self.items = [ShoppingItem()]
                        self.tableView.reloadData()
                        return
                    }
                    
                    if page == 1
                    {
                        self.items = [ShoppingItem]()
                    }
                    self.items += tmpItems
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Wrong Username or Password!")
                }
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Refresh
    @objc func refresh(_ sender: Any)
    {
        self.webTask(page: 1)
        self.nextItemNumForWebTask = 19
    }
    
    func refreshBegin(_ newtext:String, refreshEnd:(Int) -> ())
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.webTask(page: 1)
        }
    }
    
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShoppingItemInfoSegue"
        {
            if let destinationVC = segue.destination as? ShoppingItemInfoViewController, let row = tableView.indexPathForSelectedRow?.row
            {
                destinationVC.item = items[row]
            }
            else
            {
                showAlert(withString: "Somethin wrong with show segue!")
            }
        }
    }
    
    // MARK: - Alertable
    func showAlert(controller: UIViewController, title: String, withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
    func showAlert(title: String = "Error", withString str: String)
    {
        showAlert(controller: self, title: title, withString: str)
    }

}
