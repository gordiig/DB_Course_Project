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
        super.viewDidLoad()
        user = CurrentUser.getUser
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            self.deleteWebTask(indexPath.row)
        }
    }

}
