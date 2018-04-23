//
//  MyItemsViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 23.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class MyItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, Alertable
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var items = [ShoppingItem]()
    var showingItems = [ShoppingItem]()
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        self.webTask()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        showingItems = [ShoppingItem]()
        
        items = [ShoppingItem]()
        tableView.reloadData()
        
        showAlert(withString: "Did recieve memory warning! Refresh the item table.")
    }
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return showingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemTableCell") as? ShoppingItemTableViewCell else
        {
            print("Can't dequeue")
            return UITableViewCell()
        }
        
        cell.itemTitleLabel.text = showingItems[indexPath.row].name
        cell.itemPriceLabel.text = String(describing: showingItems[indexPath.row].price)
        cell.imgBase64 = showingItems[indexPath.row].img
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            self.deleteWebTask(indexPath.row)
        }
    }
    
    
    // MARK: - Web task
    func webTask()
    {
        let currentUser = CurrentUser.getUser
        let username = currentUser.username
        
        let finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/get_shopping_items/user/\(username)")!
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
                        self.showAlert(withString: "Something wrong with incame items!")
                        print("Data: \n\(String(describing: String(data: data, encoding: .utf8)))")
                        return
                    }
                    self.items += tmpItems
                    
                    self.searchBar(self.searchBar, textDidChange: self.searchBar.text ?? "")
                    self.tableView.reloadData()
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Wrong Username or Password!")
                }
            }
            
            defer
            {
                DispatchQueue.main.async
                {
                    self.refreshControl.endRefreshing()
                }
            }
        }
        
        task.resume()
    }
    
    func deleteWebTask(_ row: Int)
    {
        let currentUser = CurrentUser.getUser
        let username = currentUser.username
        let password = currentUser.password
        
        let idToDelete = items[row].ID
        
        let finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/delete_shopping_item/\(username)/\(password)/\(idToDelete)")!
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
            if ans?.first == "0"
            {
                DispatchQueue.main.async
                {
                    self.items.remove(at: row)
                    
                    self.searchBar(self.searchBar, textDidChange: self.searchBar.text ?? "")
                    self.tableView.reloadData()
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error while deleting item!\n")
                }
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - UISearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.isEmpty
        {
            showingItems = items
        }
        else
        {
            showingItems = items.filter(
                {item -> Bool in
                    let text = searchText.lowercased()
                    let name = item.name.lowercased()
                    
                    return name.contains(text)
                }
            )
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Refresh
    @objc func refresh(_ sender: Any)
    {
        self.items = [ShoppingItem]()
        self.webTask()
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
