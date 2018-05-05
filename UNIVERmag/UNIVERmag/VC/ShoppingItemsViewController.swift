//
//  ShoppingItemsViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ShoppingItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Alertable, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var addBut: UIBarButtonItem!
    @IBOutlet weak var maxPriceField: UITextField!
    @IBOutlet weak var minPriceField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBlurView: UIVisualEffectView!
    
    var showingItems = [ShoppingItem]()
    var savedBeforeWebTasksItems = [ShoppingItem]()
    var pickArr = [Category]()
    
    private let itemsPerPage: Int = 20
    private var nextItemNumForWebTask = 19
    private let refreshControl = UIRefreshControl()
    private var edgePanRecognizer: UIScreenEdgePanGestureRecognizer!
    private var panRecognizer: UIPanGestureRecognizer!
    private var categoriesForFilter = [Int]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true

        tableView.delegate = self
        tableView.dataSource = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizerHandler(_:)))
        self.view.addGestureRecognizer(panRecognizer)
        
        menuBlurView.frame.origin.x = -228
        
        self.webTask(page: 1)
        self.webTaskCat()
    }
    
    
    // MARK: - Menu works
    @IBAction func menuButPressed(_ sender: UIBarButtonItem)
    {
        if menuBlurView.frame.origin.x == 0
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations:
            {
                self.menuBlurView.frame.origin.x = -228
            }, completion: nil)
            menuDidDissapear()
        }
        else
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations:
            {
                self.menuBlurView.frame.origin.x = 0
            }, completion: nil)
            menuDidAppear()
        }
    }
    
    @objc func panRecognizerHandler(_ sender: UIPanGestureRecognizer)
    {
        guard let panView = sender.view else
        {
            showAlert(withString: "Something wrong with Pan view\n")
            return
        }
        
        let trans = sender.translation(in: panView.superview)
        
        if sender.state == .began || sender.state == .changed
        {
            let coef: CGFloat = trans.x > 0 ? 150 : 50
            menuBlurView.frame.origin.x += trans.x / coef
        }
        else if sender.state == .ended
        {
            let destX = trans.x > 0 ? 0 : -menuBlurView.frame.width
            let _ = trans.x > 0 ? menuDidAppear() : menuDidDissapear()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations:
            {
                self.menuBlurView.frame.origin.x = destX
            }, completion: nil)
        }
    }
    
    func menuDidAppear()
    {
        tableView.isUserInteractionEnabled = false
        addBut.isEnabled = false
    }
    
    func menuDidDissapear()
    {
        tableView.isUserInteractionEnabled = true
        addBut.isEnabled = true
    }
    
    
    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if component == 0
        {
            return pickArr.count + 1
        }
        else if component == 1
        {
            let row = pickerView.selectedRow(inComponent: 0)
            if row == 0
            {
                return 0
            }
            return pickArr.count == 0 ? 0 : (pickArr[row-1].subcategories.count + 1)
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if component == 0
        {
            return row == 0 ? "All" : pickArr[row-1].name
        }
        else
        {
            let fRow = pickerView.selectedRow(inComponent: 0)
            if fRow == 0
            {
                return nil
            }
            return row == 0 ? "All" : pickArr[fRow-1].subcategories[row-1].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if component == 0
        {
            pickerView.reloadComponent(1)
        }
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
    
    func webTaskCat()
    {
        let finalURL = URL(string: "https://sql-handler.herokuapp.com/handler/get_subcategories/all/")!
        let urlRequest = URLRequest(url: finalURL)
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: urlRequest)
        {
            (data, response, error) in
            
            if error != nil
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Can't get categories:\n \(error!.localizedDescription)")
                }
                print("Error in GET:\n \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "Error in downloaded data (cat)!\n")
                }
                print("Error in downloaded data:\n")
                return
            }
            
            let ans = String(data: data, encoding: .utf8)
            if ans?.first != "0"
            {
                DispatchQueue.main.async
                {
                    guard let pickArr = Category.categoriesFabric(fromData: data) else
                    {
                        self.showAlert(withString: "Error with decoding categories!\n")
                        return
                    }
                    self.pickArr = pickArr
                    self.pickerView.reloadAllComponents()
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.showAlert(withString: "No categories!")
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
