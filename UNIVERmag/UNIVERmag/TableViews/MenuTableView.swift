//
//  MenuTableView.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 07.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class MenuTableView: UITableView, UITableViewDelegate, UITableViewDataSource
{
    var categories = CurrentCategories.cur
    {
        didSet
        {
            selectedSubcats = [Bool]()
            for _ in 0 ..< categories.catAndSubcatCount
            {
                selectedSubcats.append(false)
            }
            
            self.reloadData()
        }
    }
    var selectedSubcats = [Bool]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.catAndSubcatCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if categories.categoriesIndexesInOneLayer.contains(indexPath.row)
        {
            guard let cell = self.dequeueReusableCell(withIdentifier: "categoriesTableView") as? CategoryTableViewCell else
            {
                return UITableViewCell()
            }
            cell.nameLabel.text = categories.inOneLayer[indexPath.row].name
            
            return cell
        }
        else
        {
            guard let cell = self.dequeueReusableCell(withIdentifier: "subcategoriesTableView") as? SubcategoryTableViewCell else
            {
                return UITableViewCell()
            }
            cell.nameLabel.text = categories.inOneLayer[indexPath.row].name
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let oneLayer = categories.inOneLayer
        var cell = self.cellForRow(at: indexPath)
        
        let accessoryType: UITableViewCellAccessoryType = cell?.accessoryType == .none ? .checkmark : .none
        let boolVal = accessoryType == .none ? true : false
        
        cell?.accessoryType = accessoryType
        selectedSubcats[indexPath.row] = boolVal
        
        if oneLayer[indexPath.row].ID == nil
        {
            var index = indexPath.row + 1
            let maxIndex = oneLayer.count
            
            while index < maxIndex && oneLayer[index].ID == nil
            {
                cell = self.cellForRow(at: IndexPath(row: index, section: 0))
                cell?.accessoryType = accessoryType
                selectedSubcats[index] = boolVal
                index += 1
            }
        }
        
    }
}






