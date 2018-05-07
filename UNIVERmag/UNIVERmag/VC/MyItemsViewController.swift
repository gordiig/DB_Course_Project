//
//  MyItemsViewController.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 30.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class MyItemsViewController: UserItemsViewController
{

    override func viewDidLoad()
    {
        user = CurrentUser.getUser
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            self.deleteWebTask(indexPath.row)
        }
    }
    
    func deleteWebTask(_ row: Int)
    {
        let currentUser = CurrentUser.getUser
        let username = currentUser.username
        let password = currentUser.password!
        
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
            if ans?.first != "0"
            {
                DispatchQueue.main.async
                {
                    self.items.remove(at: row)
                    
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
                    self.showAlert(withString: "Error while deleting item!\n")
                }
            }
        }
        
        task.resume()
    }
}
