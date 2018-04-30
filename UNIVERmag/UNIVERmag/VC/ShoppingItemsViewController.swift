//
//  ShoppingItemsViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ShoppingItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Alertable, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBlurView: UIVisualEffectView!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    var showingItems = [ShoppingItem]()
    var savedBeforeWebTasksItems = [ShoppingItem]()
    private let itemsPerPage: Int = 20
    private var nextItemNumForWebTask = 19
    private let refreshControl = UIRefreshControl()
    private var panRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        menuLeading.constant = -228
        
        self.webTask(page: 1)
    }
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return showingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == nextItemNumForWebTask
        {
            nextItemNumForWebTask += itemsPerPage
            savedBeforeWebTasksItems = showingItems
            webTask(page: ((indexPath.row+1) / itemsPerPage) + 1)
        }
        
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

    
    // MARK: - UISearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        savedBeforeWebTasksItems = showingItems
        showingItems = [ShoppingItem]()
        
        var searchStr = searchBar.text ?? "NULL"
        if searchStr == ""
        {
            searchStr = "NULL"
        }
        nextItemNumForWebTask = itemsPerPage-1
        webTask(page: 1, searchStr: searchStr)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = nil
        
        savedBeforeWebTasksItems = showingItems
        showingItems = [ShoppingItem]()
        
        nextItemNumForWebTask = itemsPerPage-1
        webTask(page: 1)
    }
    
    
    // MARK: - Web task
    func webTask(page: Int, searchStr: String = "NULL")
    {
        let search_str = searchStr.lowercased()
        
        let finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/get_shopping_items/\(page)/search/\(search_str)")!
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
                    self.showingItems = self.savedBeforeWebTasksItems
                }
                print("Error in GET:\n \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error in downloaded data! Please try again!\n")
                    self.showingItems = self.savedBeforeWebTasksItems
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
                        self.showingItems = self.savedBeforeWebTasksItems
                        return
                    }
                    
                    if page == 1
                    {
                        self.showingItems = [ShoppingItem]()
                    }
                    self.showingItems += tmpItems
                    
                    if (searchStr != "NULL") || (page == 1)
                    {
                        let range = NSMakeRange(0, self.tableView.numberOfSections)
                        let sections = NSIndexSet(indexesIn: range)
                        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                    }
                    else
                    {
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "No items for your result!")
                    self.searchBar.text = nil
                    self.showingItems = self.savedBeforeWebTasksItems
                }
            }
            
            defer
            {
                DispatchQueue.main.async
                {
                    self.refreshControl.endRefreshing()
                    self.savedBeforeWebTasksItems = [ShoppingItem]()
                }
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Refresh
    @objc func refresh(_ sender: Any)
    {
        self.savedBeforeWebTasksItems = showingItems
//        self.showingItems = [ShoppingItem]()
        self.searchBar.text = nil
        
        self.nextItemNumForWebTask = itemsPerPage - 1
        self.webTask(page: 1)
    }
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShoppingItemInfoSegue"
        {
            if let destinationVC = segue.destination as? ShoppingItemInfoViewController, let row = tableView.indexPathForSelectedRow?.row
            {
                destinationVC.item = showingItems[row]
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

    
    // MARK: - DidReceiveMemoryWarning
    override func didReceiveMemoryWarning()
    {
        savedBeforeWebTasksItems = [ShoppingItem]()
        showingItems = [ShoppingItem]()
        nextItemNumForWebTask = itemsPerPage - 1
        
        showAlert(withString: "Did recieve memory warning! Refresh the item table.")
    }
}
