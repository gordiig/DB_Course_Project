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
        
        for_border()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        
        self.delegate = self
        self.dataSource = self
        
        for_border()
    }
    
    func for_border()
    {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var label = view as? UILabel
        
        if label == nil
        {
            label = UILabel()
            label?.font = UIFont(descriptor: UIFontDescriptor(name: "Helvetica", size: 12), size: 12)
            label?.textAlignment = .center
        }
        
        label?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        return label!
    }
}
