//
//  NumPriceTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

class NumPriceTableViewCell: BaseTableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    let amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0.00"
        textfield.textAlignment = .right
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    override func configure() {
        [nameLabel, amountTextField].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.width.equalTo(50)
            make.centerY.equalTo(self)
        }
        

    }
    
}
