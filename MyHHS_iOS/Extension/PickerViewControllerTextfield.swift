//
//  ActionSheetViewController.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//


import UIKit

class PickerViewControllerTextfield: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var titleArray = [String]()
    var selected : Int = 0
    var picker: UIPickerView!
    typealias CompletionHandler = (_ index : Int, _ isCancel : Bool) -> Void
    var completionVar : CompletionHandler?
    
    override init() {
        super.init()
    }
    
    func manualPicker(_ sender : UITextField, width : CGFloat, titleArray : [String], selectedrow : Int, completionHandler : @escaping CompletionHandler) {
        completionVar = completionHandler
        self.titleArray = titleArray
        
        picker = UIPickerView(frame: CGRect.zero)
        picker.backgroundColor = UIColor.white
        selected = 0
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(selectedrow, inComponent: 0, animated: true)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "done".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(PickerViewControllerTextfield.donePicker(_:)))
        doneButton.tag = 201
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(PickerViewControllerTextfield.donePicker(_:)))
        cancelButton.tag = 202
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sender.inputView = picker
        sender.inputAccessoryView = toolBar
    }
    
    @objc func donePicker(_ sender : UIBarButtonItem) {
        if sender.tag == 201 {
            completionVar!(selected, false)
        } else {
            completionVar!(selected, true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titleArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = row
    }
}
