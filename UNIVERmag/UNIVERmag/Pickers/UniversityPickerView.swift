//
//  UniversityPickerView.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 20.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import UIKit

class UniversityPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    let curUn = CurrentUniversities.cur
    
    
    // MARK: - inits
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    
    // MARK: - delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return curUn.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return curUn[row].fullName
    }
}
