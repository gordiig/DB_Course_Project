//
//  MyItemsViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 23.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class UserItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, Alertable
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var items = [ShoppingItem]()
    var showingItems = [ShoppingItem]()
    var user = User()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let username = user.username
        self.title = "\(username)'s items"
        self.webTask(username: username)
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
        cell.itemUploaderLabel.text = showingItems[indexPath.row].uploaderUserName ?? "Debug"
        cell.imgBase64 = showingItems[indexPath.row].img
        if showingItems[indexPath.row].isSold
        {
            cell.itemPriceLabel.text = "Sold"
        }
        else
        {
            cell.itemPriceLabel.text = String(describing: showingItems[indexPath.row].price)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    
    
    // MARK: - Web task
    func webTask(username: String)
    {
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Can't get userinfo. Please try again!:\n \(error!.localizedDescription)")
            }
        }
        
        let dataErrorHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error in downloaded data! Please try again!\n")
            }
        }
        
        let succsessHandler: (Data, String?) -> Void =
        { (data, ans) in
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
                    
                    // self.tableView.reloadData()
                    let range = NSMakeRange(0, self.tableView.numberOfSections)
                    let sections = NSIndexSet(indexesIn: range)
                    self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(title: "No items found", withString: "It seems you haven't uploaded any items. It's easy, just press the \"+\" button on the top bar!")
                }
            }
        }
        
        let deferBody: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.refreshControl.endRefreshing()
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.userItemsWebTask(username: username, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
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
        
        // tableView.reloadData()
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Refresh
    @objc func refresh(_ sender: Any)
    {
        self.items = [ShoppingItem]()
        
        let username = user.username
        self.webTask(username: username)
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
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
