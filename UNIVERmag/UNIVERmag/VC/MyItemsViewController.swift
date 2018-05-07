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
        guard let password = currentUser.password else
        {
            showAlert(withString: "Log in first!")
            return
        }
        
        let idToDelete = items[row].ID
        
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
        
        let succsessHandler: (Data) -> Void =
        { (data) in
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
        
        let failHandler: () -> Void =
        {
            DispatchQueue.main.async
            {
                self.showAlert(withString: "Error while deleting item!\n")
            }
        }
        
        let tasker = CurrentWebTasker.tasker
        tasker.deleteWebTask(username: username, password: password, idToDelete: idToDelete, errorHandler: errorHandler, dataErrorHandler: dataErrorHandler, succsessHandler: succsessHandler, failHandler: failHandler, deferBody: {})
    }
}
