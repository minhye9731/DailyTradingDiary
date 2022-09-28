//
//  TradeDateTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

class TradeDateTableViewCell: BaseTableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "* 매매일자"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    let textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0000.00.00"
        textfield.textAlignment = .center
        return textfield
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .subBackgroundColor
        datePicker.tintColor = .pointColor
        return datePicker
    }()
    
    override func configure() {
        [nameLabel, datePicker].forEach {
            contentView.addSubview($0)
        }
        giveColorString(label: nameLabel, colorStr: "*", color: .systemRed)
        
    }
    
    override func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self)
        }
        
        datePicker.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
        }
    }
}
