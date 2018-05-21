//
//  ShoppingItemsViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 05.03.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class ShoppingItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Alertable, UISearchBarDelegate, UITextFieldDelegate
{
    @IBOutlet weak var addBut: UIBarButtonItem!
    @IBOutlet weak var maxPriceField: UITextField!
    @IBOutlet weak var minPriceField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBlurView: UIVisualEffectView!
    @IBOutlet weak var menuTableView: MenuTableView!
    @IBOutlet weak var onlyExchangeableSwitch: UISwitch!
    @IBOutlet weak var searchSegmentControl: UISegmentedControl!
    
    var showingItems = [ShoppingItem]()
    var savedBeforeWebTasksItems = [ShoppingItem]()
    var categoriesArr = CurrentCategories.cur
    
    private let itemsPerPage: Int = 20
    private var nextItemNumForWebTask = 19
    private let refreshControl = UIRefreshControl()
    private let menuRefreshControl = UIRefreshControl()
    private var edgePanRecognizer: UIScreenEdgePanGestureRecognizer!
    private var panRecognizer: UIPanGestureRecognizer!
    private var categoriesForFilter = [Int]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addBut.isEnabled = !(CurrentUser.getUser is LookingUser)
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true

        tableView.delegate = self
        tableView.dataSource = self
        
        menuTableView.alertDelegate = self
        menuRefreshControl.addTarget(self, action: #selector(webTaskCat), for: .valueChanged)
        menuTableView.refreshControl = menuRefreshControl
        
        maxPriceField.delegate = self
        minPriceField.delegate = self
        
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
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations:
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
        if !(CurrentUser.getUser is LookingUser)
        {
            addBut.isEnabled = true
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

    
    // MARK: - UISwitch
    @IBAction func onlyExchangeableSwitchValChanged(_ sender: Any)
    {
        searchBarSearchButtonClicked(self.searchBar)
    }
    
    
    // MARK: - UISearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.view.endEditing(true)
        
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
        self.view.endEditing(true)
        
//        savedBeforeWebTasksItems = showingItems
//        showingItems = [ShoppingItem]()
//
//        nextItemNumForWebTask = itemsPerPage-1
//        webTask(page: 1)
    }
    
    
    // MARK: - UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
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
    
    
    // MARK: - Web task
    func webTask(page: Int, searchStr: String = "NULL")
    {
        let search_str = searchStr.lowercased()
        
        let isOnlyEx = onlyExchangeableSwitch.isOn ? "true" : "false"
        
        let minText = minPriceField.text ?? "."
        var minPrice = -1
        if minText != "." && !minText.isEmpty
        {
            let mon = Money(string: minText)!
            minPrice = mon.toCents()
        }
        
        let maxText = maxPriceField.text ?? "."
        var maxPrice = -1
        if maxText != "." && !maxText.isEmpty
        {
            let mon = Money(string: maxText)!
            maxPrice = mon.toCents()
        }
        
        var searchField = ""
        let segment = searchSegmentControl.selectedSegmentIndex
        switch segment
        {
        case 0:
            searchField = "item_name"
        case 1:
            searchField = "user_name"
        case 2:
            searchField = "university_name"
        default:
            self.showAlert(withString: "Wrong segment was chosen!")
            return
        }
        
        var subcatIDs = ""
        let oneLayer = categoriesArr.inOneLayer
        let selectedSubcats = menuTableView.selectedSubcats
        for i in 0 ..< selectedSubcats.count
        {
            if selectedSubcats[i] && oneLayer[i].ID != nil
            {
                subcatIDs += "\(oneLayer[i].ID!),"
            }
        }
        if subcatIDs.isEmpty
        {
            subcatIDs = "all"
        }
        else
        {
            subcatIDs.removeLast()
        }
        
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Can't get userinfo. Please try again!:\n \(error!.localizedDescription)")
                self.showingItems = self.savedBeforeWebTasksItems
            }
        }
        
        let dataErrorHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error in downloaded data! Please try again!\n")
                self.showingItems = self.savedBeforeWebTasksItems
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
            
            
        }
        
        let deferBody: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.refreshControl.endRefreshing()
                self.savedBeforeWebTasksItems = [ShoppingItem]()
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.shoppingItemsWebTask(page: page, whatToSearch: searchField, search: search_str, minPrice: minPrice, maxPrice: maxPrice, subcatIDs: subcatIDs, isOnlyEx: isOnlyEx, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    @objc func webTaskCat()
    {
        let errorHandler: (Error?) -> Void =
        { (error) in
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Can't get categories:\n \(error!.localizedDescription)")
            }
        }
        
        let dataErrorHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error in downloaded data (cat)!\n")
            }
        }
        
        let succsessHandler: (Data, String?) -> Void =
        { (data, ans) in
            if ans?.first != "0"
            {
                DispatchQueue.main.async
                {
                    if !self.categoriesArr.decodeFromJSON(data)
                    {
                        self.showAlert(withString: "Problems with decoding categories!")
                    }
                    self.menuTableView.reloadData()
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
        
        let deferBody: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.menuRefreshControl.endRefreshing()
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.categoriesWebTask(errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, deferBody: deferBody)
    }
    
    // MARK: - Refresh
    @objc func refresh(_ sender: Any)
    {
        self.savedBeforeWebTasksItems = showingItems
        
        self.searchBar.text = nil
        
        self.nextItemNumForWebTask = itemsPerPage - 1
        self.webTask(page: 1)
//        self.webTaskCat()
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
    func showAlert(title: String = "Error", withString str: String)
    {
        let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - DidReceiveMemoryWarning
    override func didReceiveMemoryWarning()
    {
        savedBeforeWebTasksItems = [ShoppingItem]()
        showingItems = [ShoppingItem]()
        nextItemNumForWebTask = itemsPerPage - 1
        
        tableView.reloadData()
        
        showAlert(withString: "Did recieve memory warning! Refresh the item table.")
    }
}
