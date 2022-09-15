//
//  UITextField+Extension.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

extension UITextField {
    
    // 매매일지의 매매일자 입력용으로 확장한 함수
    func setDatePicker(target: Any, selector: Selector) {
            let width = self.bounds.width
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: width, height: 216))
            datePicker.datePickerMode = .date
            self.inputView = datePicker
            
            let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 44.0))
        
            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
            let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
            toolBar.setItems([cancel, flexible, barButton], animated: false)
        
            self.inputAccessoryView = toolBar
            
        }
        @objc func tapCancel() {
            self.resignFirstResponder()
        }
    
    
}
