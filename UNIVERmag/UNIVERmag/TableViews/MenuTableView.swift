//
//  MenuTableView.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 07.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class MenuTableView: UITableView, UITableViewDelegate, UITableViewDataSource, VCAlertDelegate
{
    var alertDelegate: Alertable?
    
    var categories = CurrentCategories.cur
    {
        didSet
        {
            self.reloadData()
        }
    }
    var selectedSubcats = [Bool]()
    
    
    // MARK: - inits
    override init(frame: CGRect, style: UITableViewStyle)
    {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }


    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.catAndSubcatCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if categories.categoriesIndexesInOneLayer.contains(indexPath.row)
        {
            guard let cell = self.dequeueReusableCell(withIdentifier: "categoryTableViewCell") as? CategoryTableViewCell else
            {
                if alertDelegate != nil
                {
                    showAlert(title: "Error", withString: "Error occured in dequing category cell!\n")
                }
                return UITableViewCell()
            }
            cell.nameLabel.text = categories.inOneLayer[indexPath.row].name
            cell.accessoryType = selectedSubcats[indexPath.row] ? .checkmark : .none
            
            return cell
        }
        else
        {
            guard let cell = self.dequeueReusableCell(withIdentifier: "subcategoryTableViewCell") as? SubcategoryTableViewCell else
            {
                if alertDelegate != nil
                {
                    showAlert(title: "Error", withString: "Error occured in dequing subcategory cell!\n")
                }
                return UITableViewCell()
            }
            cell.nameLabel.text = categories.inOneLayer[indexPath.row].name
            cell.accessoryType = selectedSubcats[indexPath.row] ? .checkmark : .none
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let oneLayer = categories.inOneLayer
        var cell = self.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        let accessoryType: UITableViewCellAccessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        let boolVal = accessoryType == .checkmark ? true : false
        
        cell?.accessoryType = accessoryType
        selectedSubcats[indexPath.row] = boolVal
        
        if oneLayer[indexPath.row].ID == nil
        {
            var index = indexPath.row + 1
            let maxIndex = oneLayer.count
            
            while index < maxIndex && oneLayer[index].ID != nil
            {
                cell = self.cellForRow(at: IndexPath(row: index, section: 0))
                cell?.accessoryType = accessoryType
                selectedSubcats[index] = boolVal
                index += 1
            }
        }
    }
    
    
    // MARK: - Overrides
    override func reloadData()
    {
        super.reloadData()
        
        selectedSubcats = [Bool]()
        for _ in 0 ..< categories.catAndSubcatCount
        {
            selectedSubcats.append(false)
        }
    }

    
    // MARK:- Alertable
    func showAlert(title: String, withString str: String)
    {
        alertDelegate?.showAlert(title: title, withString: str)
    }
}






