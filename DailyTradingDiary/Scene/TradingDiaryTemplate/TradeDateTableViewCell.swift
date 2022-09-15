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
        label.text = "매매일자"
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
    
    override func configure() {
        
        [nameLabel, textField].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(nameLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
    
}
